terraform {
  backend "s3" {
    bucket       = "my-remote-backend"
    key          = "state"
    region       = "eu-south-1"
    profile      = "terraform"
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

// we need this in order to create waf for cloudfront
// waf2 for cloudfront should be in us-east-1
provider "aws" {
  region  = "us-east-1"
  alias   = "us_east"
  profile = var.profile_name
}