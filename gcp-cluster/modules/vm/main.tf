resource "random_string" "random_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "google_compute_instance" "instances" {
  boot_disk {
    auto_delete = true
    device_name = "${random_string.random_suffix.result}-disk"

    initialize_params {
      image = var.image
      size  = 10
    }

    mode = var.mode
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = true

  machine_type = var.machine-type
  name         = "instance-${random_string.random_suffix.result}"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = var.subnetwork
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = var.zone
}