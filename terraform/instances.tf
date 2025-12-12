resource "google_compute_instance" "nodes" {
  for_each     = {
    "master" = "e2-micro",
    "worker" = "e2-micro",
    "edge"   = "e2-micro"
  }
  name         = "${each.key}-node"
  machine_type = each.value
  zone         = var.zone
  tags         = ["ansible-target"]

  boot_disk {
    initialize_params { image = "ubuntu-2204-jammy-v20251120" }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.name
    subnetwork = google_compute_subnetwork.custom_subnet.name
    access_config {} # IP Publique
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }
}