module "vpc" {
  source          = "./modules/vpc"
  app_name        = var.app_name
  main_cidr_block = var.main_cidr_block
}

module "subnets" {
  source               = "./modules/subnets"
  app_name             = var.app_name
  azs                  = ["eu-south-1a", "eu-south-1b"]
  vpc_id               = module.vpc.vpc_id
  private_subnet_names = var.private_subnet_names
  public_cidr          = var.public_cidr
  private_cidrs        = var.private_cidrs
  internetgw_id        = module.vpc.igw_id
  eip_allocation_id    = [for eip in aws_eip.eip : eip.allocation_id]
}

module "db" {
  source              = "./modules/documentdb"
  app_name            = var.app_name
  admin_user_name     = var.admin_user_name
  admin_user_password = var.admin_user_password
  auth_type           = var.auth_type
  subnet_ids          = module.subnets.db_subnet_id
  docdb_security      = [module.vpc.docdb_sg]
}

module "lb" {
  source               = "./modules/lb"
  app_name             = var.app_name
  sg                   = [module.vpc.lb_sg]
  alb_target_goup_port = var.alb_target_goup_port
  public_subnets_id    = module.subnets.public_subnet_ids
  vpc_id               = module.vpc.vpc_id
  alb_listner_port     = var.alb_listner_port
  alb_listner_protocol = var.alb_listner_protocol
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
}

module "ecs" {
  source               = "./modules/ecs"
  depends_on           = [module.db]
  security_groups      = [module.vpc.ecs_sg]
  ecs_image            = var.ecs_image
  account_id           = var.account_id
  region               = var.region
  app_name             = var.app_name
  family               = var.family
  container_name       = var.container_name
  ecs_container_cpu    = var.ecs_container_cpu
  ecs_container_memory = var.ecs_container_memory
  ecs_task_cpu         = var.ecs_task_cpu
  ecs_task_memory      = var.ecs_task_memory
  container_port       = var.container_port
  host_port            = var.host_port
  desired_count        = var.desired_count
  private_cidrs_id     = module.subnets.ecs_subnet_ids
  lb_target_group_arn  = module.lb.target_group_arn
  docdb_user_password  = var.docdb_user_password
  docdb_uri            = module.db.db_connection_string
  cache_endpoint       = module.cache.cache_endpoint
}

module "waf" {
  source   = "./modules/waf"
  app_name = var.app_name
  lb_arn   = module.lb.lb_arn
}

/*module "cloudfront" {
  source                 = "./modules/cloudfront"
  app_name               = var.app_name
  origin_protocol_policy = var.origin_protocol_policy
  alb_dns_name           = module.lb.alb_dns_name
  custom_header_name     = var.custom_header_name
  custom_header_value    = var.custom_header_value
  origin_id              = module.lb.lb_arn
  cache_policy_name      = var.cache_policy_name
  min_ttl                = var.min_ttl
  max_ttl                = var.max_ttl
  allowed_methods        = var.allowed_methods
  viewer_protocol_policy = var.viewer_protocol_policy
  locations              = var.locations
  price_class            = var.price_class
  is_cloudfront_staging  = var.is_cloudfront_staging
}*/