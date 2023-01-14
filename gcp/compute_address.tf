# Use: Creates the static IP address used for the K8S Ingress & domain name.

resource "google_compute_global_address" "static_ip" {
  name = "${var.compute_plane_namespace}-ip"
}