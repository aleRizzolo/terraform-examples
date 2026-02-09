output "api_endpoint" {
  value = aws_api_gateway_stage.dev.invoke_url
}

output "api_endpoint_domain" {
  value = replace(aws_api_gateway_stage.dev.invoke_url, "https://", "")
}

# WAF association requires the stage ARN, not the API ARN
output "stage_arn" {
  value = aws_api_gateway_stage.dev.arn
}
