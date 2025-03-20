# Data sources for the networking module
data "google_client_openid_userinfo" "me" {}

# Get project number dynamically for Workload Identity Federation
data "google_project" "current" {
  project_id = var.project
}

# Get the default compute service account
data "google_compute_default_service_account" "default" {
  project = var.project
}

# Get the current user's email for IAP configuration
data "google_client_config" "current" {}

# Get the current user's email for IAP configuration
locals {
  current_user_email = data.google_client_openid_userinfo.me.email
  support_email = coalesce(var.iap_settings.support_email, data.google_client_openid_userinfo.me.email)
}
