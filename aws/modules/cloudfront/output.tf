output "cf_domain_name" {
  value = aws_cloudfront_distribution.cloudfront_skinner_distribution.domain_name
}

output "cf_arn" {
  value = aws_cloudfront_distribution.cloudfront_skinner_distribution.arn
}