locals {
  docb_uri        = "mongodb://skinnerDB:${var.docdb_user_password}@skinner-docdb-724772066899.eu-south-1.docdb-elastic.amazonaws.com:27017"
  cache_endpoint  = "redis://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}"
  reader_endpoint = "redis://${var.cache_reader_endpoint[0].address}:${var.cache_reader_endpoint[0].port}"
  cors_origin     = var.cloudfront_origin
}

resource "aws_ecs_task_definition" "application_task_definition" {
  count                    = length(var.container_names)
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = "${var.family}-${count.index}"
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
      name   = var.container_names[count.index]
      image  = var.ecs_image
      cpu    = var.ecs_container_cpu
      memory = var.ecs_container_memory
      environment = [
        { "name" : "BACKEND_CORS_ORIGINS", "value" : "https://${local.cors_origin}" },
        { "name" : "MONGO_URI", "value" : local.docb_uri },
        { "name" : "REDIS_URL", "value" : local.cache_endpoint },
        { "name" : "READER_ENDPOINT", "value" : local.reader_endpoint },
        { "name" : "PATIENTTESTUSEREMAIL", "value" : var.test_patient_email },
        { "name" : "MEDICTESTUSEREMAIL", "value" : var.test_medic_email },
        { "name" : "ADMINTESTUSEREMAIL", "value" : var.test_admin_email },
        { "name" : "TESTUSERPASSWORD", "value" : var.test_user_password },
        { "name" : "PROJECT_NAME", "value" : var.app_name },
        { "name" : "SECRET_KEY", "value" : var.secret_key },
        { "name" : "BASE_URL", "value" : var.base_url },
        { "name" : "SHAP_SERVICE_URL", "value" : var.shap_url },
        { "name" : "MAIL_USERNAME", "value" : var.mail_username },
        { "name" : "MAIL_PASSWORD", "value" : var.mail_password },
        { "name" : "MAIL_FROM", "value" : var.mail_from },
        { "name" : "MAIL_PORT", "value" : var.mail_port },
        { "name" : "MAIL_SERVER", "value" : var.mail_server },
        { "name" : "MAIL_FROM_NAME", "value" : var.mail_from_name },
        { "name" : "MAIL_STARTTLS", "value" : var.mail_start_tls },
        { "name" : "MAIL_SSL_TLS", "value" : var.mail_ssl_tls },
        { "name" : "USE_CREDENTIALS", "value" : var.use_credentials },
        { "name" : "VALIDATE_CERTS", "value" : var.validate_cert },
        { "name" : "FIREBASE_CREDENTIALS_PATH", "value" : var.firebase_credentials },
        { "name" : "GOOGLE_CLIENT_ID", "value" : var.google_client_id },
        { "name" : "FACEBOOK_APP_SECRET", "value" : var.facebook_secret },
        { "name" : "FACEBOOK_APP_ID", "value" : var.facebook_app_id },
        { "name" : "RP_ID", "value" : var.rp_id },
        { "name" : "RP_NAME", "value" : var.rp_name },
        { "name" : "RP_ORIGIN", "value" : var.rp_origin }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs-${var.container_names[count.index]}"
        }
      }
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }

  tags = {
    Name = "${var.app_name}-task-definition-${count.index}"
  }
}

resource "aws_ecs_service" "service" {
  count               = length(var.container_names)
  name                = "${var.container_names[count.index]}_service"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.application_task_definition[count.index].arn
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

  dynamic "load_balancer" {
    for_each = count.index == 0 ? [1] : []
    content {
      target_group_arn = var.lb_target_group_arn
      container_name   = var.container_names[0]
      container_port   = var.container_port
    }
  }
}