locals {
  # LB id for univocity
  origin_id = var.origin_id
}

resource "aws_cloudfront_distribution" "cloudfront_my-app_distribution" {
  enabled     = true
  price_class = var.price_class
  staging     = var.is_cloudfront_staging

  web_acl_id = var.acl_arn

  origin {
    domain_name = var.alb_dns_name
    origin_id   = local.origin_id
    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.cloudfront_alb.id
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

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "${var.app_name}-cloudfront"
  }
}