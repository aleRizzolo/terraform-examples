resource "aws_cloudfront_cache_policy" "cache_policy" {
  name    = "${var.app_name}-${var.cache_policy_name}"
  comment = "Cache policy for ${var.app_name} CloudFront distribution"
  min_ttl = var.min_ttl
  max_ttl = var.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [var.custom_header_name]
      }
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}