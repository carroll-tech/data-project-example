output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "region" {
  description = "The region where the resources are deployed"
  value       = var.region
}


# DNS outputs are commented out since DNS resources are not being created
# Uncomment if you enable the DNS resources
/*
output "dns_zone_name" {
  description = "The name of the DNS zone if DNS is enabled"
  value       = var.enable_dns ? google_dns_managed_zone.domain_zone[0].name : null
}

output "dns_records" {
  description = "Map of subdomains to their corresponding IP addresses"
  value       = var.enable_dns ? {
    for i, subdomain in local.subdomain_names :
    subdomain => {
      domain = "${subdomain}.${local.domain_base}"
      ip     = google_compute_address.static_ip[i].address
      url    = "https://${subdomain}.${local.domain_base}/"
    }
  } : null
}
*/

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
