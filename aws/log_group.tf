resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.cloudwatch_log_group
  retention_in_days = var.logs_retention

  tags = {
    Environment = "dev"
    Application = "ecs"
  }
}