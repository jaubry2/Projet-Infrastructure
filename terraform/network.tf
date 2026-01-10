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

resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-all-internal"
  network = google_compute_network.custom_vpc_network.name

  # On autorise tout le trafic TCP, UDP et ICMP (ping) entre les machines
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  # On limite cette règle UNIQUEMENT aux machines qui sont dans ton sous-réseau 10.10.0.0/24
  source_ranges = ["10.10.0.0/24"]
  
  description = "Autorise les nœuds du cluster à communiquer entre eux sur tous les ports."
}

# Routeur Cloud pour le NAT
resource "google_compute_router" "nat_router" {
  name    = "router-for-nat"
  network = google_compute_network.custom_vpc_network.name
  region  = google_compute_subnetwork.custom_vpc_subnet.region
}

# Configuration du service NAT sur le routeur
resource "google_compute_router_nat" "cloud_nat" {
  name                               = "nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  
  # Achemine le trafic de TOUTES les IPs privées (non-publiques)
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
  # Utilise des IPs NAT automatiques fournies par Google
  nat_ip_allocate_option             = "AUTO_ONLY"
  
  # Définit la plage de sous-réseaux à surveiller pour le NAT
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  
  # Indique que le NAT s'applique au sous-réseau spécifique
  subnetwork {
    name                 = google_compute_subnetwork.custom_vpc_subnet.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}