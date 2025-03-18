locals {
  cd_domain = data.tfe_outputs.networking.values.static_ip_details["cd"].fqdn
}

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

  values = [ for values in fileset(path.module, "values/*.yaml"): "${file(values)}"]

  cleanup_on_fail = true
  recreate_pods   = true
  wait            = true
  wait_for_jobs   = true

  depends_on = [kubernetes_namespace.main]
}
