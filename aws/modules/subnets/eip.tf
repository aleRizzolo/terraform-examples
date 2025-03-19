resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [var.internetgw_id]

  tags = {
    Name = "nat_eip"
  }
}
