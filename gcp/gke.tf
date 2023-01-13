variable "node_size" { type = string }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/containter_cluster
resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER"]
    managed_prometheus {
      enabled = true
    }
  }
}

resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes-admin"
  display_name = "kubernetes-admin"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = var.nodecount

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.nodetype

    labels = {
      "role" = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}