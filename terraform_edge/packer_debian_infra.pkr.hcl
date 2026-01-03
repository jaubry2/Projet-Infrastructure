packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}


source "googlecompute" "image_infra" {
  project_id   = "front-edge-482211"
  zone         = "us-central1-a"

  # Image Debian 12 précise
  source_image = "debian-12-bookworm-v20251209"
  source_image_project_id = ["debian-cloud"]

  # Image finale créée par Packer
  image_name   = "image-infra-debian-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  image_family = "image-infra-debian"

  machine_type = "e2-micro"   # uniquement pour le build
  ssh_username = "debian"
}

build {
  sources = ["source.googlecompute.image_infra"]

  provisioner "shell" {
    script = "script_packer_infra.sh"
  }
}
