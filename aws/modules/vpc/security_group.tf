# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

# ALB Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "alb_allow_tls_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "${var.app_name}-allow_incoming_tls-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "${var.app_name}-allow_incoming-sg"
  }
}

# ECS Security Group for ALB Inbound Traffic
resource "aws_security_group" "ecs_from_alb_sg" {
  name        = "ecs-from-alb-sg"
  description = "Security group for ECS to allow inbound traffic from ALB only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-ecs-from-alb-sg"
  }
}

# ECS Security Group for DocumentDB Egress
resource "aws_security_group" "ecs_to_docdb_sg" {
  name        = "ecs-to-docdb-sg"
  description = "Security group for ECS to allow egress to DocumentDB only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-ecs-to-docdb-sg"
  }
}

# ALB Egress Rule - restrict to ECS only
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ecs_from_alb_sg.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-alb_to_ecs-sg"
  }
}

# ECS Ingress Rule - allow from ALB only
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_from_alb_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-ecs_from_alb-sg"
  }
}

# ToDo: DocumentDB Security Group