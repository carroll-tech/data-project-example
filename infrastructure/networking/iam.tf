# Service account for networking operations
resource "google_service_account" "network_admin" {
  account_id   = "network-admin-sa"
  display_name = "Network Administrator Service Account"
  description  = "Service account for managing VPC networks and firewall rules"
}

# IAM role bindings for the service account
resource "google_project_iam_member" "network_admin_roles" {
  for_each = toset([
    "roles/compute.networkAdmin",     # Manage VPCs, subnets, routes
    "roles/compute.securityAdmin",    # Manage firewall rules and security policies
    "roles/dns.admin",                # Manage DNS if needed
  ])
  
  project = var.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.network_admin.email}"
}

# Create a Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "${var.project_id_prefix}-github-pool"
  display_name              = "GitHub Actions Identity Pool"
  description               = "Identity pool for GitHub Actions workflows"
}

# Create a GitHub Workload Identity Provider
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "Allow GitHub Actions workflows to impersonate service accounts"
  
  # Map GitHub token claims to Google attributes
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }
  
  # Add attribute condition to restrict to specific repository in the organization
  attribute_condition = "attribute.repository==\"${var.github_organization}/data-project-example\""
  
  # GitHub-specific OIDC configuration
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Allow specific GitHub repository to impersonate the service account
# For a personal GitHub account, the format is: username/repository
resource "google_service_account_iam_binding" "github_workload_identity_binding" {
  service_account_id = google_service_account.network_admin.name
  role               = "roles/iam.workloadIdentityUser"
  
  members = [
    # Format for organization GitHub account: 
    # principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/attribute.repository/ORG_NAME/REPO_NAME
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_organization}/data-project-example"
  ]
}
