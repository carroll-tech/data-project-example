# GitHub OAuth Configuration for IAP Authentication

# IAM bindings for GitHub repository roles
# These bindings map GitHub repository roles to GCP IAM roles for IAP access

# IAM bindings for READ access (basic access to view applications)
resource "google_iap_web_backend_service_iam_binding" "read_access" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled && subdomain.github_access_level == "READ"
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with READ access
    # This is a placeholder for demonstration purposes
    # "group:github-read-access@example.com"
  ]
}

# IAM bindings for WRITE access (ability to manage applications)
resource "google_iap_web_backend_service_iam_binding" "write_access" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled && subdomain.github_access_level == "WRITE"
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with WRITE access
    # This is a placeholder for demonstration purposes
    # "group:github-write-access@example.com"
  ]
}

# IAM bindings for ADMIN access (full administrative access)
resource "google_iap_web_backend_service_iam_binding" "admin_access" {
  for_each = {
    for i, subdomain in var.subdomains :
    subdomain.name => subdomain if subdomain.iap_enabled && subdomain.github_access_level == "ADMIN"
  }
  
  project = var.project
  web_backend_service = google_compute_backend_service.backend_service[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with ADMIN access
    # This is a placeholder for demonstration purposes
    # "group:github-admin-access@example.com"
  ]
}

# Additional IAM bindings for Kubernetes access based on GitHub roles
# These would be used for kubectl access to the cluster

# IAM binding for GitHub users with READ access to the repository
resource "google_project_iam_binding" "github_read_access" {
  project = var.project
  for_each = toset(var.github_rbac.read_role_bindings)
  
  role = each.key
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with READ access
    # This is a placeholder for demonstration purposes
    # "group:github-read-access@example.com"
  ]
}

# IAM binding for GitHub users with WRITE access to the repository
resource "google_project_iam_binding" "github_write_access" {
  project = var.project
  for_each = toset(var.github_rbac.write_role_bindings)
  
  role = each.key
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with WRITE access
    # This is a placeholder for demonstration purposes
    # "group:github-write-access@example.com"
  ]
}

# IAM binding for GitHub users with ADMIN access to the repository
resource "google_project_iam_binding" "github_admin_access" {
  project = var.project
  for_each = toset(var.github_rbac.admin_role_bindings)
  
  role = each.key
  
  members = [
    "user:${local.current_user_email}",
    # In a real implementation, this would include GitHub users with ADMIN access
    # This is a placeholder for demonstration purposes
    # "group:github-admin-access@example.com"
  ]
}

# In a production environment, you would integrate with GitHub's API to:
# 1. Retrieve repository collaborators and their permission levels
# 2. Map GitHub permissions to GCP IAM roles
# 3. Dynamically update IAM bindings based on GitHub repository roles
# 4. Set up a webhook to update IAM bindings when repository collaborators change

# For demonstration purposes, this file shows the structure of how GitHub roles
# would be mapped to GCP IAM roles, but the actual integration with GitHub's API
# would require additional code outside of Terraform.
