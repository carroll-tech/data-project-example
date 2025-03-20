locals {
  # Extract just the names for outputs and references
  subdomain_names = [for s in var.subdomains : s.name]
  
  # Compute subnet regions if not specified
  subnet_regions = [for s in var.subnets : s.region != null ? s.region : var.region]
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

#--------------------------------------------------------------
# VPC and Subnet Resources for Kubernetes Cluster
#--------------------------------------------------------------

# Create the VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  
  description = "VPC network for Kubernetes cluster"
}

# Create subnets
resource "google_compute_subnetwork" "subnets" {
  count                    = length(var.subnets)
  name                     = var.subnets[count.index].name
  ip_cidr_range            = var.subnets[count.index].ip_cidr_range
  region                   = local.subnet_regions[count.index]
  network                  = google_compute_network.vpc.id
  private_ip_google_access = var.subnets[count.index].private_ip_google_access
  
  # Configure secondary ranges for Kubernetes pods and services
  dynamic "secondary_ip_range" {
    for_each = var.subnets[count.index].secondary_ip_ranges != null ? [1] : []
    content {
      range_name    = "pods"
      ip_cidr_range = coalesce(
        var.subnets[count.index].secondary_ip_ranges.pods,
        local.default_secondary_ranges.pods
      )
    }
  }
  
  dynamic "secondary_ip_range" {
    for_each = var.subnets[count.index].secondary_ip_ranges != null ? [1] : []
    content {
      range_name    = "services"
      ip_cidr_range = coalesce(
        var.subnets[count.index].secondary_ip_ranges.services,
        local.default_secondary_ranges.services
      )
    }
  }
}

# Firewall rules for Kubernetes cluster
resource "google_compute_firewall" "allow_internal" {
  count   = var.firewall_rules.allow_internal == true ? 1 : 0
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "tcp"
  }
  
  allow {
    protocol = "udp"
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [for subnet in var.subnets : subnet.ip_cidr_range]
  description   = "Allow internal traffic between instances in the VPC"
}

resource "google_compute_firewall" "allow_health_checks" {
  count   = var.firewall_rules.allow_health_checks == true ? 1 : 0
  name    = "${var.vpc_name}-allow-health-checks"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "tcp"
  }
  
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  description   = "Allow health checks from Google Cloud load balancers"
}

resource "google_compute_firewall" "allow_api_server" {
  count   = var.firewall_rules.allow_api_server == true ? 1 : 0
  name    = "${var.vpc_name}-allow-api-server"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  
  source_ranges = [var.firewall_rules.api_server_cidr]
  description   = "Allow access to the Kubernetes API server"
}
