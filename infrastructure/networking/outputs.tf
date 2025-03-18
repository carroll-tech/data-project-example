output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "region" {
  description = "The region where the resources are deployed"
  value       = var.region
}

# Comprehensive map of static IP details
output "static_ip_details" {
  description = "Map of static IP names to their complete details"
  value = {
    for i, ip in google_compute_address.static_ip :
    ip.name => {
      fqdn        = "${var.subdomains[i].name}.${local.domain_base}"
      ip_address  = ip.address
      description = ip.description
      self_link   = ip.self_link
      subdomain   = var.subdomains[i].name
      https_url   = "https://${var.subdomains[i].name}.${local.domain_base}/"
      network_tier = var.subdomains[i].network_tier
      address_type = var.subdomains[i].address_type
    }
  }
  sensitive = true
}

output "subdomain_configs" {
  description = "The complete subdomain configurations used"
  value       = var.subdomains
}
