locals {
  projectId      = "projet-infrastructure"
  image          = "ubuntu-2204-jammy-v20251120"
  sshUser        = "terraform-user"
  ssh_public_key_path = "~/.ssh/gcp_vm_key.pub"
  region         = "europe-west1"
  zone           = "europe-west1-b"
}

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

## We choose GCP as provider
provider "google" {
  project = local.projectId
  region  = local.region
}

## VPC network
resource "google_compute_network" "custom_vpc_network" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
}

## Subnet VPC
resource "google_compute_subnetwork" "custom_vpc_subnet" {
  name          = "custom-vpc-subnet"
  region        = local.region
  network       = google_compute_network.custom_vpc_network.id
  ip_cidr_range = "10.10.0.0/24"
}

## Firewall
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
## Master Node
resource "google_compute_instance" "master_node" {
  name         = "master-node"
  machine_type = "e2-micro"
  zone         = local.zone
    tags = ["http-server", "ansible-target", "ssh-access"]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network    = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.ssh_public_key_path)}"
  }
}
## Worker Node
resource "google_compute_instance" "worker_node" {
  name         = "worker-node"
  machine_type = "e2-micro"
  zone         = local.zone
    tags = ["http-server", "ansible-target", "ssh-access"]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network    = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.ssh_public_key_path)}"
  }
}

## Edge Node
resource "google_compute_instance" "edge_node" {
  name         = "edge-node"
  machine_type = "e2-micro"
  zone         = local.zone
    tags = ["http-server", "ansible-target", "ssh-access"]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
  network_interface {
    network    = google_compute_network.custom_vpc_network.name
    subnetwork = google_compute_subnetwork.custom_vpc_subnet.name
    ## Permet d'obtenir une adresse IP publique éphémère 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${local.sshUser}:${file(local.ssh_public_key_path)}"
  }
}
output "master_node_ip" {
  description = "L'adresse IP externe du Master Node."
  value       = google_compute_instance.master_node.network_interface.0.access_config.0.nat_ip
}
