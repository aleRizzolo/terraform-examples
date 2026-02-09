resource "aws_vpc" "main" {
  cidr_block           = var.main_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}