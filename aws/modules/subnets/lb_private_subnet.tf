resource "aws_subnet" "lb_subnet" {
  count             = 2
  vpc_id            = var.vpc_id
  cidr_block        = var.lb_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.app_name}-alb-subnet"
  }
}