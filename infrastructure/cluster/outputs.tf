output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.main.name
}

output "cluster_id" {
  description = "The unique identifier of the GKE cluster"
  value       = google_container_cluster.main.id
}
