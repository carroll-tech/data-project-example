provider "google" {
  project = data.tfe_outputs.cluster.values.project
  region  = data.tfe_outputs.cluster.values.region
}