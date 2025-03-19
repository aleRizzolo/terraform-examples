resource "aws_nat_gateway" "public_natgw" {
  allocation_id = var.eip_allocation_id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "public_natgw"
  }

  depends_on = [var.internetgw_id]
}