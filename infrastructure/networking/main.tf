resource "google_compute_address" "static_ip" {
  count        = var.ip_count
  name         = "${var.project}-static-ip-${count.index + 1}"
  region       = var.region
  address_type = var.address_type
  description  = var.description
  network_tier = var.network_tier
  
  labels = var.labels
}
