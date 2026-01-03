# VPC (MTU 1460)
resource "google_compute_network" "vpc_front" {
  name                    = "vpc-front-edge"
  auto_create_subnetworks = false
  mtu                     = 1460
}

# Subnet IPv4 only: 10.10.10.0/24
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-front-edge"
  region        = var.region
  network       = google_compute_network.vpc_front.id
  ip_cidr_range = "192.168.20.0/24"

  # IPv4 only
  stack_type = "IPV4_ONLY"

  # Souvent utile si tes VM privées doivent accéder aux APIs Google via IP privées
  private_ip_google_access = true
} 

# Peering avec le vpc edge (a modifier)
resource "google_compute_network_peering" "peer_edge_to_spark" {
  name         = "peer-edge-to-spark"
  network      = google_compute_network.vpc_front.id
  peer_network = "projects/cluster-spark-482013/global/networks/vpc-cluster-spark"
  export_custom_routes = true
  import_custom_routes = true
}

# Ingress depuis Internet : ICMP + SSH
resource "google_compute_firewall" "allow_icmp_ssh" {
  name      = "fw-allow-icmp-ssh-from-internet"
  network   = google_compute_network.vpc_front.id
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }

}

# Ingress depuis le subnet spark et edge : tout autoriser
resource "google_compute_firewall" "allow_all_from_subnet" {
  name      = "fw-allow-all-from-subnet"
  network   = google_compute_network.vpc_front.id
  direction = "INGRESS"
  priority  = 900  # plus prioritaire que 1000 (plus petit = plus prioritaire)

  source_ranges = [google_compute_subnetwork.subnet.ip_cidr_range, "10.10.10.0/24"]

  allow {
    protocol = "all"
  }
}
