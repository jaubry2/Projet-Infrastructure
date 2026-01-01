#Creation des projets
resource "google_project" "cluster_spark" {
  name            = "cluster-spark"
  project_id      = "cluster-spark-482013"
  org_id          = var.org_id
  folder_id       = var.folder_id != "" ? var.folder_id : null
  billing_account = var.billing_account_id
}

resource "google_project" "front_edge" {
  name            = "front-edge"
  project_id      = "front-edge-482211"
  org_id          = var.org_id
  folder_id       = var.folder_id != "" ? var.folder_id : null
  billing_account = var.billing_account_id
}

# Activer les APIs essentielles 
locals {
  common_apis = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}

resource "google_project_service" "cluster_spark_apis" {
  for_each           = toset(local.common_apis)
  project            = google_project.cluster_spark.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_project_service" "front_edge_apis" {
  for_each           = toset(local.common_apis)
  project            = google_project.front_edge.project_id
  service            = each.value
  disable_on_destroy = false
}
