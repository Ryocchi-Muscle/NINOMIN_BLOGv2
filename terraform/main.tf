# --------------------------------------------------------------------------------------------------
# Provider Configuration
# --------------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
}

# --------------------------------------------------------------------------------------------------
# Storage: S3 Bucket
# --------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "static_site" {
  bucket = "ryoninomiyas-portfolio-prd-static-assets"

  tags = {
    Name        = "Portfolio Static Assets"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# --------------------------------------------------------------------------------------------------
# Security: Origin Access Control (OAC)
# --------------------------------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --------------------------------------------------------------------------------------------------
# Delivery: CloudFront Distribution
# --------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id                = "S3-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    viewer_protocol_policy = "redirect-to-https" # Security: Force HTTPS
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# --------------------------------------------------------------------------------------------------
# Access Control: S3 Bucket Policy (OAC integration)
# --------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "static_site_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.static_site_policy.json
}

# --------------------------------------------------------------------------------------------------
# Observability: CloudWatch Logs
# --------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/portfolio/deployment-logs"
  retention_in_days = 7 # FinOps: Minimize storage cost based on past incidents
}
