resource "aws_subnet" "private_subnets" {
  for_each   = var.private_cidrs
  vpc_id     = var.vpc_id
  cidr_block = each.value

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "nat_route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_natgw.id
  }

  tags = {
    Name = "test-route-table"
  }
}

resource "aws_route_table_association" "aoosciation_privatesubA" {
  subnet_id      = aws_subnet.private_subnets["private_subnetA"].id
  route_table_id = aws_route_table.nat_route.id
}