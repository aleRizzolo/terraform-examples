module "vpc" {
  source          = "./modules/vpc"
  app_name        = var.app_name
  main_cidr_block = var.main_cidr_block
  azs             = var.azs
}

module "subnets" {
  source               = "./modules/subnets"
  app_name             = var.app_name
  azs                  = ["eu-south-1a", "eu-south-1b"]
  vpc_id               = module.vpc.vpc_id
  private_subnet_names = var.private_subnet_names
  public_cidr          = var.public_cidr
  private_cidrs        = var.private_cidrs
  lb_subnet_cidr       = var.lb_subnet_cidr
  internetgw_id        = module.vpc.igw_id
  eip_allocation_id    = module.vpc.eip_allocation_id
}

/*module "db" {
  source = "./modules/dynamodb"
  app_name = var.app_name
  billing_mode = var.billing_mode
}*/

module "lb" {
  source                = "./modules/lb"
  app_name              = var.app_name
  sg                    = [module.vpc.lb_sg]
  lb_target_group_port  = var.lb_target_group_port
  private_lb_subnets_id = module.subnets.private_lb_subnets_id
  vpc_id                = module.vpc.vpc_id
  lb_listener_port      = var.lb_listener_port
  health_interval       = var.health_interval
  health_port           = var.health_port
}

module "cache" {
  source                     = "./modules/cache"
  app_name                   = var.app_name
  minimum_cache_usage_limits = var.minimum_cache_usage_limits
  maximum_cache_usage_limits = var.maximum_cache_usage_limits
  daily_snapshot_time        = var.daily_snapshot_time
  description                = var.description
  snapshot_retention_limit   = var.snapshot_retention_limit
  cache_subnet_ids           = module.subnets.cache_subnet_ids
  sg_ids                     = [module.vpc.elasticache_sg]
  maximum_ecpu_seconds       = var.maximum_ecpu_seconds
  minimum_ecpu_seconds       = var.minimum_ecpu_seconds
}

/*module "waf" {
  source                = "./modules/waf"
  app_name              = var.app_name
  locations             = var.locations
  api_gateway_stage_arn = module.api_gateway.stage_arn
}*/

module "api_gateway" {
  source       = "./modules/api_gateway"
  app_name     = var.app_name
  nlb_arn      = module.lb.lb_arn
  nlb_dns_name = module.lb.nlb_dns_name
}

module "vpc_endpoint" {
  source             = "./modules/vpc_endpoint"
  app_name           = var.app_name
  vpc_id             = module.vpc.vpc_id
  region             = var.region
  subnet_ids         = module.subnets.ecs_subnet_ids
  route_table_ids    = module.subnets.private_route_table_ids
  security_group_ids = []
}

module "ecs" {
  source                            = "./modules/ecs"
  security_groups                   = [module.vpc.ecs_sg]
  ecs_image                         = var.ecs_image
  account_id                        = var.account_id
  region                            = var.region
  app_name                          = var.app_name
  family                            = var.family
  log_group_name                    = aws_cloudwatch_log_group.ecs_logs.name
  cloudwatch_log_group              = var.cloudwatch_log_group
  ecs_container_cpu                 = var.ecs_container_cpu
  ecs_container_memory              = var.ecs_container_memory
  ecs_task_cpu                      = var.ecs_task_cpu
  ecs_task_memory                   = var.ecs_task_memory
  container_port                    = var.container_port
  desired_count                     = var.desired_count
  private_cidrs_id                  = module.subnets.ecs_subnet_ids
  lb_target_group_arn               = module.lb.target_group_arn
  cache_endpoint                    = module.cache.cache_endpoint
  cache_reader_endpoint             = module.cache.cache_reader_endpoint
  test_patient_email                = var.test_patient_email
  test_medic_email                  = var.test_medic_email
  test_admin_email                  = var.test_admin_email
  test_user_password                = var.test_user_password
  secret_key                        = var.secret_key
  shap_url                          = var.shap_url
  mail_username                     = var.mail_username
  mail_password                     = var.mail_password
  mail_from                         = var.mail_from
  mail_port                         = var.mail_port
  mail_server                       = var.mail_server
  mail_from_name                    = var.mail_from_name
  mail_start_tls                    = var.mail_start_tls
  mail_ssl_tls                      = var.mail_ssl_tls
  use_credentials                   = var.use_credentials
  validate_cert                     = var.validate_cert
  firebase_credentials              = var.firebase_credentials
  google_client_id                  = var.google_client_id
  facebook_secret                   = var.facebook_secret
  facebook_app_id                   = var.facebook_app_id
  rp_id                             = var.rp_id
  rp_name                           = var.rp_name
  rp_origin                         = var.rp_origin
  origin                            = module.api_gateway.api_endpoint_domain
  log_arn                           = aws_cloudwatch_log_group.ecs_logs.arn
  aws_deploy                        = var.aws_deploy
  cert_name                         = var.cert_name
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  autoscaling_max_capacity          = var.autoscaling_max_capacity
  autoscaling_min_capacity          = var.autoscaling_min_capacity
}