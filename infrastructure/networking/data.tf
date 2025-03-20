# Data sources for the networking module
data "google_client_openid_userinfo" "me" {}

# Get project number dynamically for Workload Identity Federation
data "google_project" "current" {
  project_id = var.project
}
