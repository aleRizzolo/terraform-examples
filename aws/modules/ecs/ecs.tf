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

resource "aws_ecs_task_definition" "application_task_definition" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsondecode([
    {
      name      = var.container_name
      image     = var.ecs_image
      cpu       = var.ecs_container_cpu
      memory    = var.ecs_container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])

  tags = {
    Name = "${var.app_name}-task-definition"
  }
}

resource "aws_ecs_service" "main_app" {
  name            = "main app"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.application_task_definition.arn
  desired_count   = var.desidered_count

  /*ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }*/
}