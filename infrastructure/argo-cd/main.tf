locals {
  # Construct a proper DNS name using the project name
  cd_domain = "cd.${data.tfe_outputs.networking.nonsensitive_values.project}.net"

  # Define Helm set values here
  helm_set_values = [
    # Add values as needed
  ]
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = var.kubernetes_namespace
  }
}

resource "helm_release" "core" {
  name      = var.core_helm_release_name
  namespace = kubernetes_namespace.main.metadata[0].name
  version   = var.core_helm_chart_version

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  # Using empty values list since core-values directory is empty
  values = []

  dynamic "set" {
    for_each = local.helm_set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  cleanup_on_fail = true
  recreate_pods   = true
  wait            = true
  wait_for_jobs   = true

  depends_on = [kubernetes_namespace.main]
}

resource "helm_release" "apps" {
  name      = var.apps_helm_release_name
  namespace = kubernetes_namespace.main.metadata[0].name
  version   = var.apps_helm_chart_version

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"

  values = [file("${path.module}/app-values/core-app.yaml")]

  cleanup_on_fail = true
  recreate_pods   = true
  wait            = true
  wait_for_jobs   = true

  depends_on = [helm_release.core]
}
