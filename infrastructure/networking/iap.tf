# IAP (Identity-Aware Proxy) Configuration for GitHub Authentication

# Create an OAuth brand for IAP
resource "google_iap_brand" "default" {
  support_email     = local.support_email
  application_title = var.iap_settings.application_title
  project           = data.google_project.current.project_id
}

# Create an OAuth client for IAP
resource "google_iap_client" "default" {
  display_name = "GitHub OAuth Client"
  brand        = google_iap_brand.default.name
}

# IAP Web Backend Service IAM Member for each subdomain
resource "google_iap_web_backend_service_iam_member" "member" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  member = "user:${local.current_user_email}"
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
      each.key == "root" ? local.domain_base : "${each.key}.${local.domain_base}",
      each.key == "root" ? "*.${local.domain_base}" : "*.${each.key}.${local.domain_base}"
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
  ip_address = google_compute_address.static_ip[index(local.subdomain_names, each.key)].address
}
