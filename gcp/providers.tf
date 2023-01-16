terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
  backend "gcs" {
    bucket = "tf-test-jlittle"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
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

/* TODO: Create webhook for the team repo in Terraform
This will be auto integrated with Argo Events and trigger an Argo Worfklow to build/publish apps
to a container registry (GCR, ECR, JFrog, etc.)
provider github {
  owner = var.owner
  token = var.github_token
}
*/

# Need to use kubectl because kubernetes provider expects cluster to already be created, even if dependencies are set properly.
provider "kubectl" {
  host  = "https://${resource.google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    resource.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

