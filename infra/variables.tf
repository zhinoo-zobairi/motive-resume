variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "domain_name" {
  description = "Domain name for your site (e.g., josephaleto.io)"
  type        = string
  default     = ""  # Optional - set when adding S3/Route53
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for DNS records"
  type        = string
  default     = ""  # Optional - set when adding S3/Route53
}