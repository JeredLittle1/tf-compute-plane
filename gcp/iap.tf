# ! Note: If using IAP, you must enable TLS on all your ingress resources for GKE.
# ! Note: You also need to enable the domains with the API: https://cloud.google.com/iap/docs/allowed-domains
resource "google_project_service" "project_service" {
  service = "iap.googleapis.com"
}