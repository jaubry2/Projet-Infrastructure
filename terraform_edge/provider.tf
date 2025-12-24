terraform { 
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "front-edge-482211"
  region  = "us-central1"
  impersonate_service_account = "admin-edge@front-edge-482211.iam.gserviceaccount.com"
}


