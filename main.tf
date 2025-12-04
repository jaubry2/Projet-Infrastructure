locals {
  projectId      = "projet-infrastructure"
  image          = "ubuntu-2204-jammy-v20251120"
  sshUser        = "ansible"
  privateKeyPath = "~/.ssh/ansbile_ed25519"
  region         = "europe-west1"
  zone           = "europe-west1-b"
}

## We choose GCP as provider
provider "google" {
  project = local.projectId
  region  = local.region
}

## VPC network
resource "google_compute_network" "custom_vpc_network" {
  name                            = "custom-vpc-network"
  auto_create_subnetworks         = false
  description                     = "Réserau VPC pour l'infrastructure."
  delete_default_routes_on_create = true
  mtu                             = 1460
}

## Subnet VPC
resource "google_compute_subnetwork" "custom_vpc_subnet" {
  name          = "custom-vpc-subnet"
  network       = google_compute_network.custom_vpc_network.id
  ip_cidr_range = "10.10.0.0/24" # Plage CIDR à définir
  region        = local.region
  description   = "Sous-réseau principal pour l'infrastructure."
}

## Firewall
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-for-ansible"
  # Associer cette règle au réseau VPC
  network = google_compute_network.custom_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"] # Port standard pour SSH
  }

  source_ranges = ["0.0.0.0/0"] # Autoriser depuis n'importe où (à restreindre pour la production)

  # Ciblez le Master Node via son tag "http-server" ou ajoutez un tag "ansible"
  target_tags = ["http-server"] 
  description = "Autorise le trafic SSH entrant pour la connexion Ansible."
}

## Master Node
resource "google_compute_instance" "master_node" {
  name         = "master-node"
  machine_type = "e2-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.privateKeyPath)}"
  }
}

## Worker Node
resource "google_compute_instance" "worker_node" {
  name         = "worker-node"
  machine_type = "e2-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.privateKeyPath)}"
  }
}

resource "google_compute_instance" "edge_node" {
  name         = "edge-node"
  machine_type = "e2-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.privateKeyPath)}"
  }
}
