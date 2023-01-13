resource "google_compute_global_address" "static_ip" {
  name = "${var.compute_plane_namespace}-ip"
}