# variables.tf
variable "project_id" {
  description = "Nom du projet sur GCP"
  type        = string
  default     = "projet-infrastructure"
}
variable "region" {
  description = "Région où réservé les machines"
  type        = string
  default     = "europe-west1"
}
variable "zone" {
  description = "Zone dans la région"
  type        = string
  default     = "europe-west1-b"
}
variable "ssh_user" {
  description = "Nom de l'utilisateur SSH"
  type        = string
  default     = "newsletters_box149_gmail_com"
}
variable "ssh_pub_key" {
  description = "Lien vers la clé publique SSH"
  type        = string
  default     = "/Users/jules/.ssh/google_compute_engine.pub"
}
