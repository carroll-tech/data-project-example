locals {
  # Define any local variables here
  domain_base = "data-project-example.net"
  
  # Default secondary IP ranges for Kubernetes
  default_secondary_ranges = {
    pods     = "10.16.0.0/12"
    services = "10.32.0.0/16"
  }
}

#--------------------------------------------------------------
# GitHub Authentication Variables
#--------------------------------------------------------------

variable "github_oauth_client_id" {
  description = "GitHub OAuth client ID for IAP authentication"
  type        = string
  sensitive   = true
  default     = null
}

variable "github_oauth_client_secret" {
  description = "GitHub OAuth client secret for IAP authentication"
  type        = string
  sensitive   = true
  default     = null
}

variable "github_oauth" {
  description = "GitHub OAuth configuration for IAP authentication (deprecated, use github_oauth_client_id and github_oauth_client_secret instead)"
  type = object({
    client_id     = string
    client_secret = string
  })
  sensitive = true
  default   = null
}

locals {
  # Use the flat variables if provided, otherwise fall back to the object
  github_oauth_client_id     = coalesce(var.github_oauth_client_id, try(var.github_oauth.client_id, null))
  github_oauth_client_secret = coalesce(var.github_oauth_client_secret, try(var.github_oauth.client_secret, null))
}

variable "github_rbac" {
  description = "GitHub RBAC configuration mapping repository roles to application access"
  type = object({
    read_role_bindings  = optional(list(string), ["roles/iap.httpsResourceAccessor"])
    write_role_bindings = optional(list(string), ["roles/iap.httpsResourceAccessor", "roles/container.developer"])
    admin_role_bindings = optional(list(string), ["roles/iap.httpsResourceAccessor", "roles/container.admin"])
  })
  default = {}
}

#--------------------------------------------------------------
# Workload Identity Federation Variables
#--------------------------------------------------------------

variable "project_id_prefix" {
  description = "Prefix for the Workload Identity Pool ID (alphanumeric, hyphens allowed)"
  type        = string
  default     = "dataproj"
}

variable "github_username" {
  description = "GitHub username that owns the repository"
  type        = string
  default     = "jolfr"  # Replace with your actual GitHub username
}

variable "project" {
  description = "GCP project to deploy resources within"
  type        = string
  default     = "data-project-example-454322"
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
    address_type = optional(string, "EXTERNAL")
    description  = optional(string, "")
    iap_enabled  = optional(bool, true)
    github_access_level = optional(string, "READ") # READ, WRITE, or ADMIN
  }))
  default = [
    {
      name = "root",
      address_type = "EXTERNAL",
      github_access_level = "READ"
    },
    {
      name = "cd",
      address_type = "EXTERNAL",
      github_access_level = "WRITE"
    }
  ]
}

variable "enable_dns" {
  description = "Whether to create DNS records for the static IPs (currently disabled due to permission issues)"
  type        = bool
  default     = false
}

variable "enable_iap" {
  description = "Whether to enable Identity-Aware Proxy (IAP) for application authentication. Requires the project to be part of an organization."
  type        = bool
  default     = true
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
    allow_iap = optional(bool, true)
    api_server_cidr = optional(string, "0.0.0.0/0")
  })
  default = {}
}

# IAP Configuration
variable "iap_settings" {
  description = "Identity-Aware Proxy settings for application access"
  type = object({
    oauth_brand_name = optional(string, "data-project-example")
    support_email = optional(string)
    application_title = optional(string, "Data Project Example")
  })
  default = {}
}
