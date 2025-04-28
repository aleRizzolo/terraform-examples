resource "aws_ecs_task_definition" "application_task_definition" {
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
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

  # required because of requires_compatibilities
  runtime_platform {
    operating_system_family = "LINUX"
  }

  tags = {
    Name = "${var.app_name}-task-definition"
  }
}

resource "aws_ecs_service" "main_app" {
  name            = "main app"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.application_task_definition.arn
  desired_count   = var.desidered_count

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.lb_arn
    container_name   = "mongo"
    container_port   = 8080
  }

  /*placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }*/
}