locals {
  # Define any local variables here
  domain_base = "data-project-example.net"
  
  # Default secondary IP ranges for Kubernetes
  default_secondary_ranges = {
    pods     = "10.16.0.0/12"
    services = "10.32.0.0/16"
  }
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

# VPC Configuration
variable "vpc_name" {
  description = "Name of the VPC to create"
  type        = string
  default     = "k8s-vpc"
}

variable "auto_create_subnetworks" {
  description = "Whether to create subnetworks automatically"
  type        = bool
  default     = false
}

variable "routing_mode" {
  description = "The network routing mode (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "Routing mode must be either REGIONAL or GLOBAL."
  }
}

# Subnet Configuration
variable "subnets" {
  description = "List of subnet configurations for the Kubernetes cluster"
  type = list(object({
    name                     = string
    ip_cidr_range            = string
    region                   = optional(string)
    private_ip_google_access = optional(bool, true)
    secondary_ip_ranges = optional(object({
      pods     = optional(string)
      services = optional(string)
    }))
  }))
  default = [{
    name          = "k8s-subnet"
    ip_cidr_range = "10.0.0.0/20"
    secondary_ip_ranges = {
      pods     = "10.16.0.0/12"
      services = "10.32.0.0/16"
    }
  }]
}

# Firewall Configuration
variable "firewall_rules" {
  description = "Firewall rules for the Kubernetes cluster"
  type = object({
    allow_internal = optional(bool, true)
    allow_health_checks = optional(bool, true)
    allow_api_server = optional(bool, true)
    api_server_cidr = optional(string, "0.0.0.0/0")
  })
  default = {}
}
