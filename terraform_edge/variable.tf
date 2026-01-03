variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "ssh_user" {
  type    = string
  default = "admin"
}

variable "my_public_key" {
  type    = string
  default = "/home/joshuajn02/.ssh/admin.pub"
}
