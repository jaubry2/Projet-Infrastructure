terraform { 
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "cluster-spark-482013"
  region  = "us-central1"
  impersonate_service_account = "admin-spark@cluster-spark-482013.iam.gserviceaccount.com"
}


