locals {
  projectId      = "projet-infrastructure"
  image          = "ubuntu-2204-jammy-v20251120"
  sshUser        = "ansible"
  privateKeyPath = "~/.ssh/ansbile_ed25519"
  region         = "europe-west1"
}

## We choose GCP as provider
provider "google" {
  project = local.projectId
  region  = local.region
}

resource "google_compute_network" "custom_vpc_network" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false 
  description             = "VPC network for custom infrastructure"
  delete_default_routes_on_create = true 
  mtu                     = 1460
}