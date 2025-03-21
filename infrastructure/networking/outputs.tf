output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "region" {
  description = "The region where the resources are deployed"
  value       = var.region
}

# Main IP and domain information
output "main_ip_address" {
  description = "The main entry point IP address for all domains"
  value       = google_compute_global_address.main_static_ip.address
  sensitive   = true
}

# Domain information with single IP structure
output "domain_details" {
  description = "Domain and subdomain details with the single entry point"
  value = {
    main_ip = {
      ip_address = google_compute_global_address.main_static_ip.address
      self_link = google_compute_global_address.main_static_ip.self_link
    }
    domains = {
      for subdomain in var.subdomains :
      subdomain.name => {
        fqdn = subdomain.name == "root" ? local.domain_base : "${subdomain.name}.${local.domain_base}"
        https_url = "https://${subdomain.name == "root" ? "" : "${subdomain.name}."}${local.domain_base}/"
        github_access_level = subdomain.github_access_level
      }
    }
    wildcard_enabled = var.enable_wildcard_dns
  }
  sensitive = true
}

output "subdomain_configs" {
  description = "The complete subdomain configurations used"
  value       = var.subdomains
}

# Certificate information
output "ssl_certificate" {
  description = "The main SSL certificate details"
  value = {
    name = google_compute_managed_ssl_certificate.main_ssl_cert.name
    id = google_compute_managed_ssl_certificate.main_ssl_cert.id
    domains = local.domain_names
  }
  sensitive = true
}

#--------------------------------------------------------------
# VPC and Subnet Outputs
#--------------------------------------------------------------

output "vpc" {
  description = "The VPC resource"
  value = {
    id         = google_compute_network.vpc.id
    self_link  = google_compute_network.vpc.self_link
    name       = google_compute_network.vpc.name
    gateway_ipv4 = google_compute_network.vpc.gateway_ipv4
  }
  sensitive = true
}

output "subnets" {
  description = "Map of subnet names to their details"
  value = {
    for i, subnet in google_compute_subnetwork.subnets :
    subnet.name => {
      id                  = subnet.id
      self_link           = subnet.self_link
      ip_cidr_range       = subnet.ip_cidr_range
      region              = subnet.region
      gateway_address     = subnet.gateway_address
      secondary_ip_ranges = subnet.secondary_ip_range
    }
  }
  sensitive = true
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for subnet in google_compute_subnetwork.subnets :
    subnet.name => subnet.id
  }
  sensitive = true
}

output "subnet_self_links" {
  description = "Map of subnet names to their self-links"
  value = {
    for subnet in google_compute_subnetwork.subnets :
    subnet.name => subnet.self_link
  }
  sensitive = true
}

output "subnet_secondary_ranges" {
  description = "Map of subnet names to their secondary IP ranges"
  value = {
    for subnet in google_compute_subnetwork.subnets :
    subnet.name => subnet.secondary_ip_range
  }
  sensitive = true
}

#--------------------------------------------------------------
# IAM and Workload Identity Federation Outputs
#--------------------------------------------------------------

output "workload_identity_provider" {
  description = "The full resource name of the Workload Identity Provider"
  value       = "projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id}"
  sensitive   = true
}

output "network_service_account_email" {
  description = "The email of the service account that GitHub Actions will impersonate"
  value       = google_service_account.network_admin.email
  sensitive   = true
}

output "workload_identity_pool_name" {
  description = "The name of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_pool.display_name
  sensitive   = true
}

output "workload_identity_provider_display_name" {
  description = "The display name of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github_provider.display_name
  sensitive   = true
}

output "network_service_account_name" {
  description = "The name of the service account for network administration"
  value       = google_service_account.network_admin.display_name
  sensitive   = true
}

#--------------------------------------------------------------
# IAP and OAuth Outputs
#--------------------------------------------------------------

output "iap_oauth_client" {
  description = "The IAP OAuth client configuration"
  value       = local.enable_iap ? google_iap_client.default[0].client_id : null
  sensitive   = true
}

output "github_oauth_client_id" {
  description = "The GitHub OAuth client ID for IAP authentication"
  value       = var.github_oauth_client_id
  sensitive   = true
}

output "iap_web_backend_service_configs" {
  description = "The IAP web backend service configurations"
  value       = { for k, v in google_iap_web_backend_service_iam_binding.backend_access : k => v.web_backend_service }
  sensitive   = true
}

output "url_map" {
  description = "The main URL map for host-based routing"
  value = {
    name = google_compute_url_map.main_url_map.name
    id = google_compute_url_map.main_url_map.id
    default_service = google_compute_url_map.main_url_map.default_service
  }
  sensitive = true
}

output "cloud_dns" {
  description = "Cloud DNS configuration details"
  value = var.enable_dns ? {
    zone_name = google_dns_managed_zone.domain_zone[0].name
    dns_name = google_dns_managed_zone.domain_zone[0].dns_name
    name_servers = google_dns_managed_zone.domain_zone[0].name_servers
  } : null
  sensitive = true
}
