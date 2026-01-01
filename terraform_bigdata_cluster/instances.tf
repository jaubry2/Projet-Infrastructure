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

  # Activation authentification ssh avec OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }

  allow_stopping_for_update = true
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

  # Activation authentification ssh avec OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }

  allow_stopping_for_update = true
}


# Association de la clé ssh au compte admin 
data "google_client_openid_userinfo" "me" {
}

resource "google_os_login_ssh_public_key" "default" {
  user = data.google_client_openid_userinfo.me.email
  key  = file(var.my_public_key)
}
