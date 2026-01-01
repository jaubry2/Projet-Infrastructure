# VPC (MTU 1460)
resource "google_compute_network" "vpc_cluster" {
  name                    = "vpc-cluster-spark"
  auto_create_subnetworks = false
  mtu                     = 1460
}

#
resource "local_file" "vpc_cluster_id" {
  filename = "${path.module}/../terraform_edge/vpc_cluster_id.tf"
  content  = <<-EOT
variable "vpc_cluster_id" {
  type    = string
  default = "${google_compute_network.vpc_cluster.id}" 
} 
EOT
}

# Subnet IPv4 only: 10.10.10.0/24
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-cluster-spark"
  region        = var.region
  network       = google_compute_network.vpc_cluster.id
  ip_cidr_range = "10.10.10.0/24"

  # IPv4 only
  stack_type = "IPV4_ONLY"

  # Souvent utile si tes VM privées doivent accéder aux APIs Google via IP privées
  private_ip_google_access = true
} 


# Cloud Router (requis pour Cloud NAT)
resource "google_compute_router" "router" {
  name    = "router-cluster-spark"
  region  = var.region
  network = google_compute_network.vpc_cluster.id
}

# Cloud NAT (IPv4 only)
resource "google_compute_router_nat" "nat" {
  name   = "nat-cluster-spark"
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  # Logs optionnels (pratique pour debug)
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Peering avec le vpc edge (a modifier)
resource "google_compute_network_peering" "peer_spark_to_edge" {
  name         = "peer-spark-to-edge"
  network      = google_compute_network.vpc_cluster.id
  peer_network = "projects/front-edge-482211/global/networks/vpc-front-edge"

  export_custom_routes = true
  import_custom_routes = true
}

# Ingress depuis Internet : ICMP + SSH
resource "google_compute_firewall" "allow_icmp_ssh" {
  name      = "fw-allow-icmp-ssh-from-internet"
  network   = google_compute_network.vpc_cluster.id
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Ingress depuis le subnet spark et edge : tout autoriser
resource "google_compute_firewall" "allow_all_from_subnet" {
  name      = "fw-allow-all-from-subnet"
  network   = google_compute_network.vpc_cluster.id
  direction = "INGRESS"
  priority  = 900  # plus prioritaire que 1000 (plus petit = plus prioritaire)

  source_ranges = [google_compute_subnetwork.subnet.ip_cidr_range, "20.20.20.0/24"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_route" "default_internet" {
  name       = "default-internet-route"
  network    = google_compute_network.vpc_cluster.id
  dest_range = "0.0.0.0/0"
  priority   = 1000

  next_hop_gateway = "default-internet-gateway"
}
