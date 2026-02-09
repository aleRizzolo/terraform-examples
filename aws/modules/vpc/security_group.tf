# NLB Security Group
resource "aws_security_group" "nlb_sg" {
  name        = "nlb-security-group"
  description = "Security group for NLB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-nlb-sg"
  }
}

# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-ecs-sg"
  }
}

# ElastiCache Securiy Group
resource "aws_security_group" "cache_sg" {
  name        = "elasticache-security-group"
  description = "Security group for ElastiCache to allow inbound traffic from ECS only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-cache-sg"
  }
}

# NLB Ingress Rule - Allow from anywhere on port 80
# REST API VPC Link traffic arrives via AWS-managed PrivateLink (outside VPC CIDR).
# The NLB is internal and only reachable via the VPC Link, so this is safe
# We don't know AWS managed CIDR
resource "aws_vpc_security_group_ingress_rule" "nlb_from_vpc" {
  security_group_id = aws_security_group.nlb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "${var.app_name}-nlb-ingress"
  }
}

# NLB Egress Rule to ECS
resource "aws_vpc_security_group_egress_rule" "nlb_to_ecs" {
  security_group_id            = aws_security_group.nlb_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-nlb-to-ecs-sg"
  }
}

# ECS Ingress Rule - Only from NLB
resource "aws_vpc_security_group_ingress_rule" "ecs_from_nlb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.nlb_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-ecs-from-nlb-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_allow_all_outbound" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ElastiCache Ingress Rule - Only from ECS
# aws uses port 6380 as alias. no need sg to port 6380
resource "aws_vpc_security_group_ingress_rule" "cache_from_ecs" {
  security_group_id            = aws_security_group.cache_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-cache-from-ecs-sg"
  }
}
