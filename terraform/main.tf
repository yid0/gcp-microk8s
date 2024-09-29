
provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "microk8s" {
  count         = 3
  name          = "microk8s-node-${count.index}"
  machine_type  = var.instance_type

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  tags = ["microk8s"]
}

resource "google_compute_disk" "microk8s_persistent_disk" {
  count = 3
  name  = "microk8s-persistent-disk-${count.index}"
  size  = var.disk_size
  type  = "pd-standard"
  zone  = var.zone
}

output "instance_ips" {
  value = jsonencode({ 
    for instance in google_compute_instance.microk8s : instance.name => instance.network_interface[0].access_config[0].nat_ip
  })
}

output "persistent_disks" {
  value = [for disk in google_compute_disk.microk8s_persistent_disk : disk.name]
}