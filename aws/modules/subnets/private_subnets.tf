resource "aws_subnet" "private_subnets" {
  for_each   = var.private_cidrs
  vpc_id     = var.vpc_id
  cidr_block = each.value

  tags = {
    Name = each.key
  }
}