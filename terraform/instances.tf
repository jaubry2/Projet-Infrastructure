resource "google_compute_instance" "nodes" {
  for_each = {
    "master"   = "e2-micro",
    "worker-1" = "e2-micro",
    "worker-2" = "e2-micro",
    "edge"     = "e2-micro"
  }
  name         = "${each.key}-node"
  machine_type = each.value
  zone         = var.zone
  tags         = ["http-server", "ansible-target", "ssh-access"]


  boot_disk {
    initialize_params { image = "ubuntu-2204-jammy-v20251120" }
  }

  network_interface {
    network    = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    dynamic "access_config" {
      # La condition pour attribuer une IP publique (le bloc 'access_config')
      # est vraie si 'each.key' est 'master', 'edge', ou 'worker-1'.
      for_each = (each.key == "master" || each.key == "edge" || each.key == "worker-1") ? [1] : []

      content {
        # Si vous voulez l'IP temporaire par défaut, le bloc 'content' reste vide.
      }
    }
  }
  
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }
}
