terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.56.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "instance_1" {
  name         = "master"
  machine_type = "e2-micro"

  tags = ["master"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}

resource "google_compute_firewall" "ssh-server" {
  name    = "test-firewall"
  network = "default"

  source_tags = ["master"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_network" "default" {
  name = "test-network"
}