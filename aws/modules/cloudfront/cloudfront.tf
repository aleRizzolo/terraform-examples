locals {
  origin_id = var.origin_id
}

resource "aws_cloudfront_distribution" "skinner_alb_distribution" {
  enabled     = true
  price_class = var.price_class
  staging     = var.is_cloudfront_staging

  origin {
    domain_name = var.alb_dns_name
    origin_id   = local.origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    custom_header {
      name  = var.custom_header_name
      value = var.custom_header_value
    }
  }

  default_cache_behavior {
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy.id
    allowed_methods        = var.allowed_methods
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.locations
    }
  }

  viewer_certificate {}

  tags = {
    Name = "${var.app_name}-cloudfront"
  }
}