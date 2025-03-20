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
