terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.25.0"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "jolfr-personal"

    workspaces {
      name = "data-project-example-cluster"
    }
  }
}
