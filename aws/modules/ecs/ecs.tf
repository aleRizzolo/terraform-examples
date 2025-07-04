resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-ecs-cluster"

  tags = {
    Name = "${var.app_name}-ecs-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}