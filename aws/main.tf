module "vpc" {
  source          = "./modules/vpc"
  app_name        = var.app_name
  main_cidr_block = var.main_cidr_block
}

module "subnets" {
  source            = "./modules/subnets"
  app_name          = var.app_name
  vpc_id            = module.vpc.vpc_id
  public_cidr       = var.public_cidr
  private_cidrs     = var.private_cidrs
  internetgw_id     = module.vpc.igw_id
  eip_allocation_id = [for eip in aws_eip.eip : eip.allocation_id]
}

module "lb" {
  source            = "./modules/lb"
  app_name          = var.app_name
  sg                = module.vpc.lb_sg
  public_subnets_id = module.subnets.public_subnet_ids
}

module "ecs" {
  source               = "./modules/ecs"
  app_name             = var.app_name
  family               = var.family
  container_name       = var.container_name
  ecs_container_cpu    = var.ecs_container_cpu
  ecs_container_memory = var.ecs_container_memory
  container_port       = var.container_port
  host_port            = var.host_port
  desidered_count      = var.desidered_count
}

module "db" {
  source              = "./modules/documentdb"
  app_name            = var.app_name
  admin_user_name     = var.admin_user_name
  admin_user_password = var.admin_user_password
  auth_type           = var.auth_type
  subnet_ids          = module.subnets.db_subnet_id
}