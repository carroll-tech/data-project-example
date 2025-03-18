locals {
  cd_domain = data.google_compute_address.global_static_ip.address
  
  # Define Helm set values here
  helm_set_values = [
    {
      name  = "server.ingress.enabled"
      value = "true"
    },
    {
      name  = "server.ingress.hosts[0]"
      value = local.cd_domain
    },
    {
      name  = "server.ingress.annotations.kubernetes.io/ingress.global-static-ip-name"
      value = data.google_compute_address.global_static_ip.name
    },
    # Add more values as needed
  ]
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
