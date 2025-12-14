# =============================================================================
# Static Website Infrastructure (requires domain)
# =============================================================================
# These resources are commented out until a domain is configured.
# Uncomment and update when ready to add S3 + Route53 + CloudFront.

# resource "aws_s3_bucket" "site" {
#   bucket = "your-domain.com"
#   tags = {
#     project = "Cloud Resume Challenge"
#   }
# }

# resource "aws_route53_record" "site" {
#   zone_id = var.hosted_zone_id
#   name    = var.domain_name
#   type    = "A"
#
#   alias {
#     name                   = "your-cloudfront-distribution.cloudfront.net"
#     zone_id                = "Z2FDTNDATAQYW2"
#     evaluate_target_health = false
#   }
# }
