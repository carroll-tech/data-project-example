resource "google_service_account" "nodes" {
  account_id   = local.pool_service_account_id
  display_name = var.pool_service_account_name
}

resource "google_container_cluster" "main" {
  name     = local.cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Allow cluster to be deleted by terraform
  deletion_protection = false
}

resource "google_container_node_pool" "general_nodes" {
  name       = local.general_pool_name
  location   = var.region
  cluster    = google_container_cluster.main.id

  initial_node_count = 1

  autoscaling {
    total_min_node_count = var.general_pool_min_nodes
    total_max_node_count = var.general_pool_max_nodes
  }

  node_config {
    machine_type = "e2-small"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.nodes.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}