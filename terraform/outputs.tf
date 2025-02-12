output "master_ip" {
  value = google_compute_instance.microk8s[0].network_interface[0].access_config[0].nat_ip
  description = "Microk8s master node ip address" 
}

output "worker_ips" {
  value = [
    google_compute_instance.microk8s[1].network_interface[0].access_config[0].nat_ip,
    google_compute_instance.microk8s[2].network_interface[0].access_config[0].nat_ip
  ]

  description = "Microk8s workers ip addresses"
}
