# Use: Enables IAP and adds users to be authenticated via IAP.
# ! Note: If using IAP, you must enable TLS on all your ingress resources for GKE.
# ! Note: You also need to enable the domains with the API: https://cloud.google.com/iap/docs/allowed-domains
resource "google_project_service" "project_service" {
  service = "iap.googleapis.com"
}

/*

data "google_compute_backend_service" "backend-services" {
  name = "foobar"
}

Currently manual to set up IAP members in the console.

data "google_iam_policy" "iap_users" {
  binding {
    role = "roles/iap.httpsResourceAccessor"
    members = var.iap_users
  }
}

resource "google_iap_web_backend_service_iam_policy" "iap_policy" {
  for_each = {for path in local.ingress_paths: path["backend"]["service"]["name"] => path }
  project = var.project
  web_backend_service = "k8s1-5251f33b-compute-plane-argocd-server-80-05090105"
  policy_data = data.google_iam_policy.iap_users.policy_data
  depends_on = [
    resource.kubectl_manifest.ingress
  ]
}
*/