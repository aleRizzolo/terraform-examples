resource "aws_eip" "eip" {
  count  = length(var.azs)
  domain = "vpc"

  tags = {
    Name = "nat-eip-${count.index + 1}"
  }
}
