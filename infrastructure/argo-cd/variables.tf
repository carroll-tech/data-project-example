variable "cluster_terraform_workspace" {
  description = "Terraform Cloud workspace for the cluster"
  default     = "data-project-example-cluster"
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