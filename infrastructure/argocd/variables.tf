variable "cluster_terraform_workspace" {
  description = "Terraform Cloud workspace for the cluster"
  default     = "data-project-example-cluster"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace to create and use for Argo CD deployment"
  default = "argo-cd"
}