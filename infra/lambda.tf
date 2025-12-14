# =============================================================================
# Terminal Commands Lambda Infrastructure
# =============================================================================
# This file provisions:
# - Lambda function for terminal command handling
# - API Gateway HTTP API
# - IAM role with basic execution permissions
# - CloudWatch log group
# =============================================================================

# -----------------------------------------------------------------------------
# IAM Role for Lambda
# -----------------------------------------------------------------------------
resource "aws_iam_role" "terminal_lambda_role" {
  name = "terminal-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "TerminalLambdaRole"
    Environment = "production"
    Project     = "CloudResume"
  }
}

# Attach basic Lambda execution policy (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "terminal_lambda_basic" {
  role       = aws_iam_role.terminal_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------------------------------------------------------
# Lambda Deployment Package
# -----------------------------------------------------------------------------
data "archive_file" "terminal_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/terminal-function.zip"
  excludes = [
    "*.zip",
    "node_modules/.cache",
    "coverage",
    "*.test.js"
  ]
}

# -----------------------------------------------------------------------------
# Lambda Function
# -----------------------------------------------------------------------------
resource "aws_lambda_function" "terminal_function" {
  filename      = data.archive_file.terminal_lambda_zip.output_path
  function_name = "terminal-commands"
  role          = aws_iam_role.terminal_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 30
  memory_size   = 256

  source_code_hash = data.archive_file.terminal_lambda_zip.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.terminal_lambda_basic,
    aws_cloudwatch_log_group.terminal_lambda_logs,
  ]

  tags = {
    Name        = "TerminalFunction"
    Environment = "production"
    Project     = "CloudResume"
  }
}

# -----------------------------------------------------------------------------
# CloudWatch Log Group
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "terminal_lambda_logs" {
  name              = "/aws/lambda/terminal-commands"
  retention_in_days = 14

  tags = {
    Name        = "TerminalLambdaLogs"
    Environment = "production"
    Project     = "CloudResume"
  }
}

# -----------------------------------------------------------------------------
# API Gateway HTTP API
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_api" "terminal_api" {
  name          = "terminal-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["content-type"]
    allow_methods     = ["POST", "OPTIONS"]
    allow_origins     = ["*"] # Will be tightened after domain is known
    max_age           = 86400
  }

  tags = {
    Name        = "TerminalAPI"
    Environment = "production"
    Project     = "CloudResume"
  }
}

# API Gateway stage
resource "aws_apigatewayv2_stage" "terminal_api_stage" {
  api_id      = aws_apigatewayv2_api.terminal_api.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Name        = "TerminalAPIStage"
    Environment = "production"
    Project     = "CloudResume"
  }
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "terminal_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terminal_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.terminal_api.execution_arn}/*/*"
}

# API Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "terminal_lambda_integration" {
  api_id             = aws_apigatewayv2_api.terminal_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.terminal_function.invoke_arn
}

# -----------------------------------------------------------------------------
# API Gateway Routes
# -----------------------------------------------------------------------------
# POST / - Main command endpoint
resource "aws_apigatewayv2_route" "terminal_post_route" {
  api_id    = aws_apigatewayv2_api.terminal_api.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.terminal_lambda_integration.id}"
}

# Note: OPTIONS handled automatically by cors_configuration on HTTP API

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
output "api_url" {
  description = "URL of the terminal API"
  value       = aws_apigatewayv2_api.terminal_api.api_endpoint
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.terminal_function.function_name
}
