terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

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
  public_subnets_id = module.subnets.public_subnet_ids
}