data "tfe_outputs" "cluster" {
  organization = "jolfr-personal"
  workspace    = var.cluster_terraform_workspace
}

data "tfe_outputs" "networking" {
  organization = "jolfr-personal"
  workspace    = var.networking_terraform_workspace
}

data "google_client_config" "default" {}

data "google_container_cluster" "main" {
  name = data.tfe_outputs.cluster.nonsensitive_values.cluster_name
}

data "google_compute_address" "global_static_ip" {
  name   = "${data.tfe_outputs.networking.nonsensitive_values.project}-cd"
  region = data.tfe_outputs.networking.nonsensitive_values.region
}
