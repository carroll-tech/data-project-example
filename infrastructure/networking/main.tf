locals {
  # Extract just the names for outputs and references
  subdomain_names = [for s in var.subdomains : s.name]
}

resource "google_compute_address" "static_ip" {
  count        = length(var.subdomains)
  name         = "${var.project}-${var.subdomains[count.index].name}"
  region       = var.region
  address_type = var.subdomains[count.index].address_type
  description  = coalesce(
    var.subdomains[count.index].description,
    "Static IP for ${var.subdomains[count.index].name}.${local.domain_base}"
  )
  network_tier = var.subdomains[count.index].network_tier

  labels = merge(var.labels, {
    subdomain = var.subdomains[count.index].name
    domain    = replace(local.domain_base, ".", "-")
  })
}

# Note: DNS zone and record creation is commented out due to permission issues
# Uncomment and configure if you have the necessary DNS permissions
/*
# DNS A records for the static IPs
resource "google_dns_managed_zone" "domain_zone" {
  count       = var.enable_dns ? 1 : 0
  name        = replace(local.domain_base, ".", "-")
  dns_name    = "${local.domain_base}."
  description = "DNS zone for ${local.domain_base}"
}

resource "google_dns_record_set" "domain_records" {
  count        = var.enable_dns ? length(var.subdomains) : 0
  name         = "${var.subdomains[count.index].name}.${local.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.domain_zone[0].name
  
  rrdatas = [google_compute_address.static_ip[count.index].address]
}
*/
