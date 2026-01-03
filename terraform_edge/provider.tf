terraform { 
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = "front-edge-482211"
  region  = "us-central1"
}


