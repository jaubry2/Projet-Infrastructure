locals {
  admin_roles = [
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountUser",
    "roles/compute.osAdminLogin",
  ]

  ssh_bot_roles = = [
    "roles/iam.serviceAccountUser",
    "roles/compute.osLogin"
  ]

}

#Ajouts des roles de l'admin par rapport a ses scopes (= ses deux projets)
resource "google_project_iam_member" "admin_spark_roles" {
  for_each = toset(local.admin_roles)

  project = google_project.cluster_spark.project_id
  role    = each.value
  member  = "user:${var.admin_gmail}"
}

resource "google_project_iam_member" "admin_front_roles" {
  for_each = toset(local.admin_roles)

  project = google_project.front_edge.project_id
  role    = each.value
  member  = "user:${var.admin_gmail}"
}


# Creation du compte de service ssh-bot pour le cluster-spark uniquement
resource "google_service_account" "ssh_bot" {
  project      = google_project.cluster_spark.project_id
  account_id   = "ssh-bot"
  display_name = "Account for ssh connection between VMs"
}

resource "google_project_iam_member" "admin_spark_roles" {
  for_each = toset(local.ssh_bot_roles)

  project = google_project.cluster_spark.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.ssh_bot.email}"
}


#Ajouts du role de masquerade a l'admin du cluster-spark, pour pouvoir ajouter les clés ssh de différentes VMs, si besoin
resource "google_service_account_iam_member" "ssh_bot_token_creator" {
  service_account_id = google_service_account.ssh_bot.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${var.admin_gmail}"

}
