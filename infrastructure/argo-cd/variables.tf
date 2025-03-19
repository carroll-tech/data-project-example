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

variable "helm_release_name" {
  description = "Helm release name for Argo CD deployment"
  default     = "argo-cd"
}

variable "helm_chart_version" {
  description = "Version of the helm chart to use for Argo CD deployment"
  default     = "7.8.10"
}

variable "argocd_admin_password" {
  description = "Admin password for Argo CD"
  type        = string
  sensitive   = true
}
