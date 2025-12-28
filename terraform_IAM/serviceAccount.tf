# Creation des comptes de services
resource "google_service_account" "admin_spark" {
  project      = google_project.cluster_spark.project_id
  account_id   = "admin-spark"
  display_name = "Admin service account for Spark cluster"
}

resource "google_service_account" "admin_front" {
  project      = google_project.front_edge.project_id
  account_id   = "admin-front"
  display_name = "Admin service account for Front Edge"
}


#Ajouts des roles aux comptes par rapport a leur scope (= leur projet)
locals {
  admin_roles = [
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountUser"
  ]
}

resource "google_project_iam_member" "admin_spark_roles" {
  for_each = toset(local.admin_roles)

  project = google_project.cluster_spark.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.admin_spark.email}"
}

resource "google_project_iam_member" "admin_front_roles" {
  for_each = toset(local.admin_roles)

  project = google_project.front_edge.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.admin_front.email}"
}


#Ajouts du role de masquerade aux comptes principaux de My First Project, leur permettant de se faire passer pour les comptes admin (scope des comptes principaux My First Project = comptes de services admin)
resource "google_service_account_iam_member" "admin_spark_token_creator" {
  service_account_id = google_service_account.admin_spark.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:189827128792-compute@developer.gserviceaccount.com"
}

resource "google_service_account_iam_member" "admin_front_token_creator" {
  service_account_id = google_service_account.admin_front.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:189827128792-compute@developer.gserviceaccount.com"
}
