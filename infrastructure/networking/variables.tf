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

variable "ip_count" {
  description = "Number of static IP addresses to create"
  type        = number
  default     = 1
}

variable "address_type" {
  description = "The type of address to reserve (EXTERNAL or INTERNAL)"
  type        = string
  default     = "EXTERNAL"
}

variable "description" {
  description = "An optional description of the resource"
  type        = string
  default     = "Static IP address allocated by Terraform"
}

variable "network_tier" {
  description = "The networking tier used for configuring this address (PREMIUM or STANDARD)"
  type        = string
  default     = "PREMIUM"
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
