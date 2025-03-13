data "tfe_outputs" "cluster" {
  organization = "jolfr-personal"
  workspace = var.cluster_terraform_workspace
}