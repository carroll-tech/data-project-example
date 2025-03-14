resource "kubernetes_namespace" "main" {
  metadata {
    name = var.kubernetes_namespace
  }
}