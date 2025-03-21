resource "aws_eip" "eip" {
  count      = length(var.azs)
  domain     = "vpc"
  depends_on = [module.vpc.igw_id]


  tags = {
    Name = "nat-eip-${count.index + 1}"
  }
}
