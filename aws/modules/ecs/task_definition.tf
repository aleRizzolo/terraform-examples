locals {
  # in the code, READER_ENDPOINT substitutes REDIS_URL (cache endpoint)
  # if in the future this is fixed, then change back to CERT_* strings
  cache_endpoint  = "rediss://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}/0?ssl_cert_reqs=none"
  reader_endpoint = "rediss://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}/0?ssl_cert_reqs=none"
  cors_origin     = var.cloudfront_origin
}

resource "aws_ecs_task_definition" "main_task_definition" {
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = "${var.family}-main"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  ephemeral_storage {
    size_in_gib = 100
  }

  container_definitions = jsonencode([
    {
      name   = "main"
      image  = var.ecs_image
      cpu    = var.ecs_container_cpu
      memory = var.ecs_container_memory
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs-main"
        }
      }

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }

  tags = {
    Name = "${var.app_name}-main-task-definition"
  }
}

resource "aws_ecs_task_definition" "celery_task_definition" {
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = "${var.family}-celery"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  ephemeral_storage {
    size_in_gib = 100
  }

  container_definitions = jsonencode([
    {
      name = "celery"
      command = [
        "/app/backend/.venv/bin/python",
        "-m",
        "celery",
        "-A",
        "app.celery_config.celery_app",
        "worker",
        "--loglevel=info",
        "-P",
        "solo",
        "-E"
      ]
      image  = var.ecs_image
      cpu    = var.ecs_container_cpu
      memory = var.ecs_container_memory
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs-celery"
        }
      }

      # celery doesn't need a port mapping
      portMappings = []
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }

  tags = {
    Name = "${var.app_name}-celery-task-definition"
  }
}

resource "aws_ecs_service" "main_service" {
  name                = "main_service"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.main_task_definition.arn
  scheduling_strategy = "REPLICA"
  desired_count       = var.desired_count
  force_delete        = false
  launch_type         = "FARGATE"

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.private_cidrs_id
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "main"
    container_port   = var.container_port
  }
}

resource "aws_ecs_service" "celery_service" {
  name                = "celery_service"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.celery_task_definition.arn
  scheduling_strategy = "REPLICA"
  desired_count       = var.desired_count
  force_delete        = false
  launch_type         = "FARGATE"

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.private_cidrs_id
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}