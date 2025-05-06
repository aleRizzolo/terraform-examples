output "lb_arn" {
  value = aws_lb.application_lb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.application_lb.dns_name
}