resource "aws_nat_gateway" "natgw" {
  count         = length(var.azs)
  allocation_id = var.eip_allocation_id[count.index]
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.app_name}-public_natgw"
  }
}