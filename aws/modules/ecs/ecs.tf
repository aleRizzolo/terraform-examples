resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-ecs-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = var.cloudwatch_log_group
      }
    }
  }

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