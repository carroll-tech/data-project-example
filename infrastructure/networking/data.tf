# Data sources for the networking module
data "google_client_openid_userinfo" "me" {}

# Get project number dynamically for Workload Identity Federation
data "google_project" "current" {
  project_id = var.project
}

# Get the current user's email for IAP configuration
data "google_client_config" "current" {}

# Get the current user's email for IAP configuration
locals {
  current_user_email = data.google_client_openid_userinfo.me.email
  support_email = coalesce(var.iap_settings.support_email, data.google_client_openid_userinfo.me.email)
  
  # Check if the email is a service account (ends with .gserviceaccount.com)
  is_service_account = endswith(data.google_client_openid_userinfo.me.email, ".gserviceaccount.com")
  
  # Format the email with the correct prefix based on whether it's a service account or user
  current_user_email_with_prefix = local.is_service_account ? "serviceAccount:${data.google_client_openid_userinfo.me.email}" : "user:${data.google_client_openid_userinfo.me.email}"
}
