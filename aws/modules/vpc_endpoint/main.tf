# Security group for VPC interface endpoints
resource "aws_security_group" "endpoint_sg" {
  name        = "${var.app_name}-vpc-endpoint-sg"
  description = "Security group for VPC interface endpoints"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.app_name}-vpc-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "endpoint_https" {
  security_group_id = aws_security_group.endpoint_sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "${var.app_name}-vpc-endpoint-https"
  }
}

# ECR API Interface Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = concat([aws_security_group.endpoint_sg.id], var.security_group_ids)
  private_dns_enabled = true

  tags = {
    Name = "${var.app_name}-ecr-api-endpoint"
  }
}

# ECR Docker Registry Interface Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = concat([aws_security_group.endpoint_sg.id], var.security_group_ids)
  private_dns_enabled = true

  tags = {
    Name = "${var.app_name}-ecr-dkr-endpoint"
  }
}

# S3 Gateway Endpoint (required for ECR as image layers are stored in S3)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name = "${var.app_name}-s3-endpoint"
  }
}

# DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name = "${var.app_name}-dynamodb-endpoint"
  }
}

