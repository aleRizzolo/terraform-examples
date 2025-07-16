resource "aws_cloudfront_vpc_origin" "cloudfront_alb" {
  vpc_origin_endpoint_config {
    name                   = "${var.app_name}-vpc_origin"
    arn                    = var.alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = var.origin_protocol_policy

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}