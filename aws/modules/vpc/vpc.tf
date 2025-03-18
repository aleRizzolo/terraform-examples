resource "aws_vpc" "main" {
  cidr_block = var.main_cidr_block

  tags = {
    Name = "test-vpc"
  }
}