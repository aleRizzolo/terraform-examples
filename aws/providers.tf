terraform {
  backend "s3" {
    bucket       = "my-app-remote-backend"
    key          = "state"
    region       = "eu-south-1"
    profile      = "terraform"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}