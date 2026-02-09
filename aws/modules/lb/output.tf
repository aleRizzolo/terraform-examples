output "lb_arn" {
  value = aws_lb.application_lb.arn
}

output "target_group_arn" {
  value      = aws_lb_target_group.ecs_target_group.arn
  depends_on = [aws_lb_listener.ecs_backend]
}

output "nlb_dns_name" {
  value = aws_lb.application_lb.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.ecs_backend.arn
}
