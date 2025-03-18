locals {
  # Define any local variables here
  domain_base = "data-project-example.net"
}

variable "project" {
  description = "GCP project to deploy resources within"
  type        = string
  default     = "data-project-example"
}

variable "region" {
  description = "GCP region to deploy resources within"
  type        = string
  default     = "us-central1"
}


variable "labels" {
  description = "Labels to apply to the static IP addresses"
  type        = map(string)
  default     = {}
}

variable "subdomains" {
  description = "List of subdomain configurations with their properties"
  type = list(object({
    name         = string
    network_tier = optional(string, "PREMIUM")
    address_type = optional(string, "INTERNAL")
    description  = optional(string, "")
  }))
  default = [{
    name = "cd"
  }]
}

variable "enable_dns" {
  description = "Whether to create DNS records for the static IPs (currently disabled due to permission issues)"
  type        = bool
  default     = false
}
