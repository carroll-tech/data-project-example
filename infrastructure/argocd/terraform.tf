terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.64.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.25.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "jolfr-personal"

    workspaces {
      name = "data-project-example-argocd"
    }
  }
}