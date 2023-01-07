variable gcp_project_id { type = string }
variable gcp_region { type = string }


terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0"
    }
  }
  backend "gcs" {
    bucket  = "tf-test-jlittle"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
}

data "google_client_config" "provider" {}


provider "helm" {
  kubernetes {
    host  = "https://${resource.google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      resource.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
}