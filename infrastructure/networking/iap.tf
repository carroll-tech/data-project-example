# IAP (Identity-Aware Proxy) Configuration for GitHub Authentication

# Check if IAP should be enabled
locals {
  # We need to disable IAP if the project is not part of an organization
  enable_iap = false # Disabled due to project not being part of a GCP organization
}

# IAP Brand and Client resources are commented out since the project is not part of a GCP organization
# Uncomment these resources when the project is moved to a GCP organization

/*
resource "google_iap_brand" "default" {
  count            = local.enable_iap ? 1 : 0
  support_email     = local.support_email
  application_title = var.iap_settings.application_title
  project           = data.google_project.current.project_id
}

resource "google_iap_client" "default" {
  count        = local.enable_iap && length(google_iap_brand.default) > 0 ? 1 : 0
  display_name = "GitHub OAuth Client"
  brand        = google_iap_brand.default[0].name
}
*/

# IAP Web Backend Service IAM Member for each subdomain
resource "google_iap_web_backend_service_iam_member" "member" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  member = local.current_user_email_with_prefix
}

# Backend service for each subdomain
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
  
  iap {
    oauth2_client_id     = var.github_oauth.client_id
    oauth2_client_secret = var.github_oauth.client_secret
    enabled              = true
  }
}

# Health check for each backend service
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

# URL map for each subdomain
resource "google_compute_url_map" "url_map" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  name            = "${var.project}-${each.key}-url-map"
  project         = var.project
  default_service = google_compute_backend_service.backend_service[each.key].id
}

# HTTPS target proxy for each subdomain
resource "google_compute_target_https_proxy" "https_proxy" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  name             = "${var.project}-${each.key}-https-proxy"
  project          = var.project
  url_map          = google_compute_url_map.url_map[each.key].id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_cert[each.key].id]
}

# SSL certificate for each subdomain
resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  name     = "${var.project}-${each.key}-cert"
  project  = var.project
  
  managed {
    domains = [
      each.key == "root" ? local.domain_base : "${each.key}.${local.domain_base}"
    ]
  }
}

# Global forwarding rule for each subdomain
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled && subdomain.address_type == "EXTERNAL"
  }
  
  name       = "${var.project}-${each.key}-forwarding-rule"
  project    = var.project
  target     = google_compute_target_https_proxy.https_proxy[each.key].id
  port_range = "443"
  ip_address = google_compute_global_address.static_ip[each.key].address
}
