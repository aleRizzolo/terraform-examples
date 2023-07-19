terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "instances" {
  source       = "./modules/vm"
  region       = var.region
  count        = 5
  image        = var.image
  mode         = var.mode
  machine-type = var.machine-type
  email        = var.email
  subnetwork   = var.subnetwork
  zone         = var.zone
}