provider "google" {
  project = data.tfe_outputs.cluster.nonsensitive_values.project
  region  = data.tfe_outputs.cluster.nonsensitive_values.region
}