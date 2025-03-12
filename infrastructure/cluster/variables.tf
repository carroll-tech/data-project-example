locals {
  cluster_name = "${var.project}-cluster"
}

variable "project" {
  description = "GCP project to deploy resources within"
  type = string
  default = "data-project-example"
}

variable "region" {
  description = "GCP region to deploy resources within"
  type = string
  default = "us-east4"
}