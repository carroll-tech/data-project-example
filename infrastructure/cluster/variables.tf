locals {
  cluster_name = "${var.project}-cluster"
  general_pool_name = "${var.project}-gen-np"
  pool_service_account_id = "${var.project}-node-sa"
}

variable "project" {
  description = "GCP project to deploy resources within"
  type = string
  default = "data-project-example"
}

variable "region" {
  description = "GCP region to deploy resources within"
  type = string
  default = "us-central1"
}

variable "general_pool_min_nodes" {
  description = "Minimum number of nodes in the general node pool"
  type = number
  default = 0
}

variable "general_pool_max_nodes" {
  description = "Maximum number of nodes in the general node pool"
  type = number
  default = 10
}

variable "pool_service_account_name" {
  description = "Service account name for node pool machines"
  type = string
  default = "Cluster Nodes Service Account"
}