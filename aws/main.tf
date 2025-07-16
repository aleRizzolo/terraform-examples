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
  lb_subnet_cidr       = var.lb_subnet_cidr
  internetgw_id        = module.vpc.igw_id
  eip_allocation_id    = [for eip in aws_eip.eip : eip.allocation_id]
}

module "db" {
  source                       = "./modules/documentdb"
  app_name                     = var.app_name
  admin_user_name              = var.admin_user_name
  admin_user_password          = var.admin_user_password
  subnet_ids                   = module.subnets.db_subnet_id
  azs                          = var.azs
  docdb_security               = [module.vpc.docdb_sg]
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  instance_class               = var.instance_class
}

module "lb" {
  source                 = "./modules/lb"
  app_name               = var.app_name
  sg                     = [module.vpc.lb_sg]
  alb_target_goup_port   = var.alb_target_goup_port
  private_alb_subnets_id = module.subnets.private_alb_subnets_id
  vpc_id                 = module.vpc.vpc_id
  alb_listner_port       = var.alb_listner_port
  alb_listner_protocol   = var.alb_listner_protocol
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
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  app_name               = var.app_name
  origin_protocol_policy = var.origin_protocol_policy
  alb_dns_name           = module.lb.alb_dns_name
  origin_id              = module.lb.lb_arn
  min_ttl                = var.min_ttl
  max_ttl                = var.max_ttl
  allowed_methods        = var.allowed_methods
  viewer_protocol_policy = var.viewer_protocol_policy
  locations              = var.locations
  price_class            = var.price_class
  alb_arn                = module.lb.lb_arn
  is_cloudfront_staging  = var.is_cloudfront_staging
}

/* module "waf" {
  source           = "./modules/waf"
  app_name         = var.app_name
  included_headers = var.included_headers
  cloudfront_arn   = module.cloudfront.cf_arn
}
 */
module "ecs" {
  source                = "./modules/ecs"
  depends_on            = [module.db]
  security_groups       = [module.vpc.ecs_sg]
  ecs_image             = var.ecs_image
  account_id            = var.account_id
  region                = var.region
  app_name              = var.app_name
  family                = var.family
  log_group_name        = aws_cloudwatch_log_group.ecs_logs.name
  cloudwatch_log_group  = var.cloudwatch_log_group
  container_names       = var.container_names
  ecs_container_cpu     = var.ecs_container_cpu
  ecs_container_memory  = var.ecs_container_memory
  ecs_task_cpu          = var.ecs_task_cpu
  ecs_task_memory       = var.ecs_task_memory
  container_port        = var.container_port
  host_port             = var.host_port
  desired_count         = var.desired_count
  private_cidrs_id      = module.subnets.ecs_subnet_ids
  lb_target_group_arn   = module.lb.target_group_arn
  docdb_user_password   = var.docdb_user_password
  docdb_uri             = module.db.db_connection_string
  cache_endpoint        = module.cache.cache_endpoint
  cache_reader_endpoint = module.cache.cache_reader_endpoint
  test_patient_email    = var.test_patient_email
  test_medic_email      = var.test_medic_email
  test_admin_email      = var.test_admin_email
  test_user_password    = var.test_user_password
  secret_key            = var.secret_key
  base_url              = var.base_url
  shap_url              = var.shap_url
  mail_username         = var.mail_username
  mail_password         = var.mail_password
  mail_from             = var.mail_from
  mail_port             = var.mail_port
  mail_server           = var.mail_server
  mail_from_name        = var.mail_from_name
  mail_start_tls        = var.mail_start_tls
  mail_ssl_tls          = var.mail_ssl_tls
  use_credentials       = var.use_credentials
  validate_cert         = var.validate_cert
  firebase_credentials  = var.firebase_credentials
  google_client_id      = var.google_client_id
  facebook_secret       = var.facebook_secret
  facebook_app_id       = var.facebook_app_id
  rp_id                 = var.rp_id
  rp_name               = var.rp_name
  rp_origin             = var.rp_origin
  cloudfront_origin     = module.cloudfront.cf_domain_name
  log_arn               = aws_cloudwatch_log_group.ecs_logs.arn
}