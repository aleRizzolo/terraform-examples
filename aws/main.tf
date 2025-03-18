terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./modules/vpc"
  main_cidr_block = var.main_cidr_block
}

module "subnets" {
  source        = "./modules/subnets"
  vpc_id        = module.vpc.vpc_id
  public_cidr   = var.public_cidr
  private_cidrs = var.private_cidrs
  internetgw_id = module.vpc.igw_id
}