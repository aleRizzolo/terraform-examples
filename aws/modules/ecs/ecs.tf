resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-ecs-cluster"

  tags = {
    Name = "${var.app_name}-igw"
  }
}