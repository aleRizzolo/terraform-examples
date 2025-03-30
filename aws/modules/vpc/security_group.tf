# ToDo: make this generic
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and outbound traffic to ecs"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-allow_tls-sg"
  }
}

# ALB sg
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "${var.app_name}-allow_incoming_tls-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ip4_ecs" {
  # ToDo: change to allow outbound traffic only to ecs
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${var.app_name}-allow_outbound_ecs-sg"
  }
}