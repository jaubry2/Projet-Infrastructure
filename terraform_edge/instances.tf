resource "google_compute_instance" "edge" {
  name         = "edge"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "image-infra-debian"
      #size  = 20
      type  = "pd-balanced"
    }
  }

 # une IP externe pour pouvoir joindre le edge
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
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
  project = "front-edge-482211"
  user = data.google_client_openid_userinfo.me.email
  key  = file(var.my_public_key)
}
