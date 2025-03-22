resource "aws_lb" "application_lb" {
  name               = "alb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.sg
  subnets            = var.public_subnets_id

  enable_deletion_protection = false

  tags = {
    Name = "${var.app_name}-alb"
  }
}