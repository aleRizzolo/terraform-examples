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
  main_cidr_block = var.main_cidr_block
  app_name        = var.app_name
}

module "subnets" {
  source            = "./modules/subnets"
  vpc_id            = module.vpc.vpc_id
  public_cidr       = var.public_cidr
  private_cidrs     = var.private_cidrs
  internetgw_id     = module.vpc.igw_id
  eip_allocation_id = [for eip in aws_eip.eip : eip.allocation_id]
  app_name          = var.app_name
}

module "lb" {
  source            = "./modules/lb"
  public_subnets_id = module.subnets.public_subnet_ids
}