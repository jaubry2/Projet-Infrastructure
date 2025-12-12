resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-vpc-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.custom_vpc.id
  region        = var.region
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ansible-target"]
}