# ALB Security Group
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

# ElastiCache Securiy Group
resource "aws_security_group" "cache_sg" {
  name        = "elasticache-security-group"
  description = "Security group for ElastiCache to allow inbound traffic from ECS only"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-cache-sg"
  }
}

# Since we're using vpc origins
# no need to allow from cf public ips
resource "aws_vpc_security_group_ingress_rule" "alb_from_vpc_origin" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.app_name}-alb-from-vpc-origin"
  }
}

# ALB Egress Rule to ECS
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-alb-to-ecs-sg"
  }
}

# ECS Ingress Rule - Only from ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.app_name}-ecs-from-alb-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_allow_all_outbound" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
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

# ElastiCache Ingress Rule - Only from ECS
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