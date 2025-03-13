terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.64.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.25.0"
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