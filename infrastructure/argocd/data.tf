data "tfe_outputs" "cluster" {
  organization = "jolfr-personal"
  workspace    = var.cluster_terraform_workspace
}

data "google_client_config" "default" {}

data "google_container_cluster" "main" {
  name = data.tfe_outputs.cluster.nonsensitive_values.cluster_name
}
