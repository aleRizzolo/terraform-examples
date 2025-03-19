resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [module.vpc.igw_id]

  tags = {
    Name = "eip"
  }
}
