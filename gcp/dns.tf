resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"
}

# ! Note: The DNS domain must be purchased manually via "Cloud Domains" due to no resource in TF for this
resource "google_dns_managed_zone" "dns-managed-zone" {
  name     = "jlittle-dns-zone"
  dns_name = "${var.domain_name}."
  depends_on = [
    google_project_service.dns_api
  ]
}
resource "google_dns_record_set" "nginx" {
  name = "compute-plane.${google_dns_managed_zone.dns-managed-zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-managed-zone.name
  rrdatas = [resource.google_compute_global_address.static_ip.address]
}