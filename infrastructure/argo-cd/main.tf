resource "kubernetes_namespace" "main" {
  metadata {
    name = var.kubernetes_namespace
  }
}

resource "helm_release" "main" {
  name      = var.helm_release_name
  namespace = kubernetes_namespace.main.metadata[0].name
  version   = var.helm_chart_version

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  verify     = true

  cleanup_on_fail = true
  recreate_pods   = true
  wait            = true
  wait_for_jobs   = true

  depends_on = [kubernetes_namespace.main]
}