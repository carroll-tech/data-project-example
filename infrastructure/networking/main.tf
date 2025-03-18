# Use the length of subdomains list or ip_count, whichever is greater
locals {
  subdomain_count = max(length(var.subdomains), var.ip_count)
  
  # Generate default subdomains if needed
  default_subdomains = [
    for i in range(local.subdomain_count - length(var.subdomains)) : {
      name         = "service-${i + length(var.subdomains) + 1}"
      network_tier = var.network_tier
      address_type = var.address_type
      description  = ""
    }
  ]
  
  # Combine provided and default subdomains
  effective_subdomains = length(var.subdomains) >= local.subdomain_count ? var.subdomains : concat(
    var.subdomains,
    local.default_subdomains
  )
  
  # Extract just the names for outputs and references
  subdomain_names = [for s in local.effective_subdomains : s.name]
}

resource "google_compute_address" "static_ip" {
  count        = local.subdomain_count
  name         = "${var.project}-${local.effective_subdomains[count.index].name}"
  region       = var.region
  address_type = coalesce(local.effective_subdomains[count.index].address_type, var.address_type)
  description  = coalesce(
    local.effective_subdomains[count.index].description,
    "Static IP for ${local.effective_subdomains[count.index].name}.${local.domain_base}"
  )
  network_tier = coalesce(local.effective_subdomains[count.index].network_tier, var.network_tier)

  labels = merge(var.labels, {
    subdomain = local.effective_subdomains[count.index].name
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
  count        = var.enable_dns ? local.subdomain_count : 0
  name         = "${local.effective_subdomains[count.index].name}.${local.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.domain_zone[0].name
  
  rrdatas = [google_compute_address.static_ip[count.index].address]
}
*/
