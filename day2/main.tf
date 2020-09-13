provider "google" {
  credentials = file("terraform-admin.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "ek-server" {
  name         = "${var.name}-server"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }

  metadata_startup_script = file("elkServ.sh")
}

resource "google_compute_instance" "tomcat" {
  name         = "${var.name}-client-tomcat"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }

#  depends_on = [google_compute_instance.ldap-server]
  metadata_startup_script = templatefile("startTomcat.sh", {es_ip = google_compute_instance.ek-server.network_interface.0.network_ip})
}

