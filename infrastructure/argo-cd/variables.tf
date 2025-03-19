variable "cluster_terraform_workspace" {
  description = "Terraform Cloud workspace for the cluster"
  default     = "data-project-example-cluster"
}

variable "networking_terraform_workspace" {
  description = "Terraform Cloud workspace for the networking"
  default     = "data-project-example-networking"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace to create and use for Argo CD deployment"
  default     = "argo-cd"
}

variable "core_helm_release_name" {
  description = "Helm release name for Argo CD core deployment"
  default     = "argo-cd"
}

variable "core_helm_chart_version" {
  description = "Version of the helm chart to use for Argo CD core deployment"
  default     = "7.8.10"
}

variable "apps_helm_release_name" {
  description = "Helm release name for Argo CD applications deployment"
  default     = "argo-cd-apps"
}

variable "apps_helm_chart_version" {
  description = "Version of the helm chart to use for Argo CD applications deployment"
  default     = "2.0.2"
}
