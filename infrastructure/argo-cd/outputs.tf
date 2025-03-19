output "argo_cd_core_release_name" {
  description = "The Helm release name of the Argo CD core deployment"
  value       = helm_release.core.name
}

output "argo_cd_apps_release_name" {
  description = "The Helm release name of the Argo CD applications deployment"
  value       = helm_release.apps.name
}

output "argo_cd_core_chart_version" {
  description = "The chart version of the Argo CD core deployment"
  value       = var.core_helm_chart_version
}

output "argo_cd_apps_chart_version" {
  description = "The chart version of the Argo CD applications deployment"
  value       = var.apps_helm_chart_version
}
