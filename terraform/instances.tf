resource "google_compute_instance" "nodes" {
  for_each = {
    "master"   = "e2-medium",
    "worker-1" = "e2-medium",
    "worker-2" = "e2-medium",
    "worker-3" = "e2-medium",
    "worker-4" = "e2-medium",
    "worker-5" = "e2-medium",
    "worker-6" = "e2-medium",
    "edge"     = "e2-medium"
  }
  name         = "${each.key}-node"
  machine_type = each.value
  zone         = var.zone
  tags         = ["http-server", "ansible-target", "ssh-access"]


  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20251120" # Ou l'image de votre choix
      size  = 20 # Définit la taille du disque à 20 GB
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    dynamic "access_config" {
      # La condition pour attribuer une IP publique (le bloc 'access_config')
      # est vraie si 'each.key' est 'master', 'edge', ou 'worker-1'.
      for_each = (each.key == "edge") ? [1] : []

      content {
        # Si vous voulez l'IP temporaire par défaut, le bloc 'content' reste vide.
      }
    }
  }

  metadata = {
    enable-oslogin = "TRUE" # Active le lien SSH <-> IAM
  }
}
