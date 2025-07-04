resource "aws_subnet" "public_subnet" {
  count                   = length(var.azs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public_subnet-${var.azs[count.index]}"
  }

}

resource "aws_route_table" "igw_route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internetgw_id
  }

  tags = {
    Name = "${var.app_name}-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.igw_route.id
}