output "project" {
  description = "The GCP project ID where resources are deployed"
  value       = var.project
}

output "region" {
  description = "The region where the resources are deployed"
  value       = var.region
}

output "static_ip_names" {
  description = "The names of the static IP addresses"
  value       = google_compute_address.static_ip[*].name
}

output "static_ip_addresses" {
  description = "The actual IP addresses allocated"
  value       = google_compute_address.static_ip[*].address
}

output "static_ip_self_links" {
  description = "The URI of the created resources"
  value       = google_compute_address.static_ip[*].self_link
}
