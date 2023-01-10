resource "google_dns_managed_zone" "dns-managed-zone" {
  name     = "jlittle.io"
  dns_name = "jlittle.io"
}

resource "google_dns_record_set" "example" {
  managed_zone = google_dns_managed_zone.example.dns-managed-zone

  name    = "www.${google_dns_managed_zone.dns-managed-zone.dns_name}"
  type    = "A"
  rrdatas = ["10.1.2.1", "10.1.2.2"]
  ttl     = 300
}