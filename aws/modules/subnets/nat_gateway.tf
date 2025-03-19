resource "aws_nat_gateway" "public_natgw" {
  allocation_id = aws_eip.eip.allocation_id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "public_natgw"
  }

  depends_on = [var.internetgw_id]
}