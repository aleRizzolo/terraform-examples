locals {
  docb_uri       = "mongodb://skinnerDB:${var.docdb_user_password}@skinner-docdb-724772066899.eu-south-1.docdb-elastic.amazonaws.com:27017"
  cache_endpoint = "redis://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}"
}

resource "aws_ecs_task_definition" "application_task_definition" {
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  container_definitions = jsonencode([
    {
      name   = var.container_name
      image  = var.ecs_image
      cpu    = var.ecs_container_cpu
      memory = var.ecs_container_memory
      environment = [
        { "name" : "MONGO_URI", "value" : local.docb_uri },
        { "name" : "REDIS_URL", "value" : local.cache_endpoint }
      ]
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

resource "aws_ecs_service" "service" {
  name                = "main_service"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.application_task_definition.arn
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

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}