resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"
}

# ! Note: The DNS domain must be purchased manually via "Cloud Domains" due to no resource in TF for this
# ! Note: If DNS is re-created, you will need to manually update the cloud domain to use Cloud DNS again: https://console.cloud.google.com/net-services/domains/registrations
# Otherwise, it gets removed & you won't be able to resolve your hosts.
resource "google_dns_managed_zone" "dns-managed-zone" {
  name     = "jlittle-dns-zone"
  dns_name = "${var.domain_name}."
  depends_on = [
    google_project_service.dns_api
  ]
}
resource "google_dns_record_set" "nginx" {
  for_each = {for rule in local.ingress_rules: rule["host"] => rule }
  name = "${each.key}."
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-managed-zone.name
  rrdatas = [resource.google_compute_global_address.static_ip.address]
}