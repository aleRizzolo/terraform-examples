resource "aws_subnet" "private_subnets" {
  for_each          = var.private_cidrs
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key == "private_subnetA" ? var.azs[0] : var.azs[1]

  tags = {
    Name = "${var.app_name}-${each.key}"
  }
}
resource "aws_route_table" "nat_route" {
  count  = length(var.azs)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_natgw[count.index].id
  }

  tags = {
    Name = "${var.app_name}-route-table"
  }
}

resource "aws_route_table_association" "association_privatesubA" {
  subnet_id      = aws_subnet.private_subnets["private_subnetA"].id
  route_table_id = aws_route_table.nat_route[0].id
}