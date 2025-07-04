terraform {
  backend "s3" {
    bucket = "skinner-remote-backend"
    key    = "state"
    region = "eu-south-1"
    profile = "terraform"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}
