# ALB Security Group - Accept requests from anywhere
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-alb-sg"
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

# DocumentDB Security Group
resource "aws_security_group" "docdb_sg" {
  name        = "docdb-security-group"
  description = "Security group for DocumentDB to allow inbound traffic from ECS only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-docdb-sg"
  }
}

# ALB Ingress Rules - Accept from anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_allow_tls_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "${var.app_name}-alb-allow-tls-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_http_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "${var.app_name}-alb-allow-http-sg"
  }
}

# ALB Egress Rule - Only to ECS
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-alb-to-ecs-sg"
  }
}

# ECS Ingress Rule - Only from ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-ecs-from-alb-sg"
  }
}

# ECS Egress Rule - Only to DocumentDB
resource "aws_vpc_security_group_egress_rule" "ecs_to_docdb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.docdb_sg.id
  from_port                    = 27017
  to_port                      = 27017
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-ecs-to-docdb-sg"
  }
}

# DocumentDB Ingress Rule - Only from ECS
resource "aws_vpc_security_group_ingress_rule" "docdb_from_ecs" {
  security_group_id            = aws_security_group.docdb_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 27017
  to_port                      = 27017
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-docdb-from-ecs-sg"
  }
}