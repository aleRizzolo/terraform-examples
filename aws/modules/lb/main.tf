resource "aws_lb" "application_lb" {
  name                             = "nlb"
  internal                         = true
  load_balancer_type               = "network"
  security_groups                  = var.sg
  subnets                          = var.private_lb_subnets_id
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false

  tags = {
    Name = "${var.app_name}-nlb"
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name                              = "nlb-ecs-target-group"
  port                              = var.lb_target_group_port
  protocol                          = "TCP"
  target_type                       = "ip"
  vpc_id                            = var.vpc_id
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  health_check {
    enabled  = true
    interval = var.health_interval
    protocol = "HTTP"
    matcher  = "200"
    port     = var.health_port
    path     = "/health"
  }

  tags = {
    Name = "${var.app_name}-ecs-target"
  }
}

# For ecs, target group is in ecs/task_definition.service

resource "aws_lb_listener" "ecs_backend" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = var.lb_listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
