module "vpc" {
  source          = "./modules/vpc"
  app_name        = var.app_name
  main_cidr_block = var.main_cidr_block
}

module "subnets" {
  source            = "./modules/subnets"
  app_name          = var.app_name
  azs               = ["eu-south-1a", "eu-south-1b"]
  vpc_id            = module.vpc.vpc_id
  public_cidr       = var.public_cidr
  private_cidrs     = var.private_cidrs
  internetgw_id     = module.vpc.igw_id
  eip_allocation_id = [for eip in aws_eip.eip : eip.allocation_id]
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
  private_cidrs_id     = module.subnets.private_cidrs_id
  lb_target_group_arn  = module.lb.target_group_arn
}