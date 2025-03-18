output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "region" {
  description = "The region where the resources are deployed"
  value       = var.region
}

output "static_ip_names" {
  description = "The names of the static IP addresses"
  value       = google_compute_address.static_ip[*].name
}

output "static_ip_addresses" {
  description = "The actual IP addresses allocated"
  value       = google_compute_address.static_ip[*].address
}

output "static_ip_self_links" {
  description = "The URI of the created resources"
  value       = google_compute_address.static_ip[*].self_link
}

output "subdomains" {
  description = "The subdomains used for the static IPs"
  value       = local.subdomain_names
}

output "domain_names" {
  description = "The full domain names (e.g., cd.data-project-example.net)"
  value       = [for subdomain in local.subdomain_names : "${subdomain}.${local.domain_base}"]
}

output "https_urls" {
  description = "The HTTPS URLs for the domains (e.g., https://cd.data-project-example.net/)"
  value       = [for subdomain in local.subdomain_names : "https://${subdomain}.${local.domain_base}/"]
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

# Alternative DNS-like output that doesn't depend on actual DNS resources
output "domain_ip_mapping" {
  description = "Map of domains to their corresponding IP addresses (for manual DNS configuration)"
  value = {
    for i, subdomain in local.subdomain_names :
    subdomain => {
      domain = "${subdomain}.${local.domain_base}"
      ip     = google_compute_address.static_ip[i].address
      url    = "https://${subdomain}.${local.domain_base}/"
    }
  }
}

output "subdomain_configs" {
  description = "The complete subdomain configurations used"
  value       = local.effective_subdomains
}
