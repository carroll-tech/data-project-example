# IAP (Identity-Aware Proxy) Configuration with GitHub Authentication
# This file implements a single entry point with IAP protection

locals {
  # Enable IAP for all backend services
  enable_iap = true
}

# Note: IAP Brand is created manually in the Google Cloud Console
# The brand name is provided via the existing_iap_brand variable

# IAP OAuth client for GitHub authentication
resource "google_iap_client" "default" {
  count        = local.enable_iap ? 1 : 0
  display_name = "Data Project Example"
  brand        = var.existing_iap_brand
}

# Backend services with IAP enabled for each application
resource "google_compute_backend_service" "backend_service" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  name        = "${var.project}-${each.key}-backend"
  project     = var.project
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 30
  
  health_checks = [google_compute_health_check.health_check[each.key].id]
  
  # Enable IAP with GitHub OAuth credentials
  iap {
    oauth2_client_id     = var.github_oauth_client_id
    oauth2_client_secret = var.github_oauth_client_secret
    enabled              = true
  }
}

# IAP access permissions based on GitHub roles
resource "google_iap_web_backend_service_iam_binding" "backend_access" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  
  # Map GitHub roles to IAP access permissions
  members = concat(
    [local.current_user_email_with_prefix],
    lookup(var.github_org_teams, each.value.github_access_level, [])
  )
}

# Health checks for backend services
resource "google_compute_health_check" "health_check" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  name               = "${var.project}-${each.key}-health-check"
  project            = var.project
  check_interval_sec = 5
  timeout_sec        = 5
  
  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

# Single URL map for all applications with host-based routing
resource "google_compute_url_map" "main_url_map" {
  name            = "${var.project}-main-url-map"
  project         = var.project
  default_service = google_compute_backend_service.backend_service["root"].id
  
  # Host rules for subdomains (host-based routing)
  dynamic "host_rule" {
    for_each = {
      for i, subdomain in var.subdomains :
      subdomain.name => subdomain if subdomain.iap_enabled && subdomain.name != "root"
    }
    
    content {
      hosts        = ["${host_rule.key}.${local.domain_base}"]
      path_matcher = host_rule.key
    }
  }
  
  # Path matchers for each subdomain
  dynamic "path_matcher" {
    for_each = {
      for i, subdomain in var.subdomains :
      subdomain.name => subdomain if subdomain.iap_enabled && subdomain.name != "root"
    }
    
    content {
      name            = path_matcher.key
      default_service = google_compute_backend_service.backend_service[path_matcher.key].id
    }
  }
}

# Single SSL certificate for all explicit domains
# Note: Google-managed SSL certificates do not support wildcard domains (*.example.com)
# Each subdomain that needs SSL must be explicitly added to the domains list
resource "google_compute_managed_ssl_certificate" "main_ssl_cert" {
  name     = "${var.project}-main-cert"
  project  = var.project
  
  managed {
    # Using distinct to prevent duplicate domains which cause deployment errors
    domains = distinct(local.domain_names)
  }
}

# Single HTTPS target proxy with SSL certificate
resource "google_compute_target_https_proxy" "main_https_proxy" {
  name             = "${var.project}-main-https-proxy"
  project          = var.project
  url_map          = google_compute_url_map.main_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.main_ssl_cert.id]
}

# Single global forwarding rule directing traffic to the HTTPS proxy
resource "google_compute_global_forwarding_rule" "main_forwarding_rule" {
  name       = "${var.project}-main-forwarding-rule"
  project    = var.project
  target     = google_compute_target_https_proxy.main_https_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.main_static_ip.address
}
