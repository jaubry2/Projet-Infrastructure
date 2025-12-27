resource "google_compute_instance" "master" {
  name         = "master-hdfs-spark"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12-bookworm-v20251209"
      size  = 20
      type  = "pd-balanced"
    }
  }

 # une IP externe pour pouvoir joindre le cluster
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }

  # Service Account par défaut + scope complet API
  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }

  # Ajout des clés publiques dans authorized_keys via metadata
  # Format GCE: "username:ssh-rsa AAAA... comment"
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.my_public_key)}"
  }
}



resource "google_compute_instance" "workers" {
  count        = length(local.workers_names)
  name         = local.workers_names[count.index]
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12-bookworm-v20251209"
      size  = 10
      type  = "pd-balanced"
    }
  }

  # IP interne FIXE + IP externe (éphemère)
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    }

  # Service Account par défaut + scope complet API
  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }

  # Ajout des clés publiques dans authorized_keys via metadata
  # Format GCE: "username:ssh-rsa AAAA... comment"
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.my_public_key)}"
  }
}
