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
    for subdomain_name, ip in google_compute_global_address.static_ip :
    subdomain_name => {
      fqdn        = "${subdomain_name}.${local.domain_base}"
      ip_address  = ip.address
      description = ip.description
      self_link   = ip.self_link
      subdomain   = subdomain_name
      https_url   = "https://${subdomain_name}.${local.domain_base}/"
      address_type = ip.address_type
    }
  }
  sensitive = true
}

output "subdomain_configs" {
  description = "The complete subdomain configurations used"
  value       = var.subdomains
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

output "iap_brand" {
  description = "The IAP OAuth brand configuration (null if not created)"
  value       = null
  sensitive   = true
}

output "iap_client" {
  description = "The IAP OAuth client configuration (null if not created)"
  value       = null
  sensitive   = true
}

output "github_oauth_client_id" {
  description = "The GitHub OAuth client ID for IAP authentication"
  value       = var.github_oauth.client_id
  sensitive   = true
}

output "iap_web_backend_service_configs" {
  description = "The IAP web backend service configurations"
  value       = { for k, v in google_iap_web_backend_service_iam_member.member : k => v.web_backend_service }
  sensitive   = true
}
