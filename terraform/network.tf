resource "google_compute_network" "custom_vpc_network" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_vpc_subnet" {
  name          = "custom-vpc-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.custom_vpc_network.id
  region        = var.region
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-for-ansible"
  network = google_compute_network.custom_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"] # Port standard pour SSH
  }

  source_ranges = ["0.0.0.0/0"] # Autoriser depuis n'importe où (à restreindre pour la production)

  # Ciblez le Master Node via son tag "http-server" ou ajoutez un tag "ansible"
  target_tags = ["http-server", "ansible-target", "ssh-access"]
  description = "Autorise le trafic SSH entrant pour la connexion Ansible."
}