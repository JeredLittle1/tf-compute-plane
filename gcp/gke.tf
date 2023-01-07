variable "node_size" { type = string }

resource "google_service_account" "gke_sa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = "us-east1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "gke-node-pool"
  location   = "us-east1"
  cluster    = google_container_cluster.primary.name
  autoscaling = {
    total_min_node_count = 1
    total_max_node_count = 2
  }

  node_config {
    preemptible  = false
    machine_type = var.node_size

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}