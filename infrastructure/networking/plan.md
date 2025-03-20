# Plan for Adding Private VPC and Subnet Resources for Kubernetes Cluster

Based on the existing Terraform configuration in the `infrastructure/networking/` directory, I'll create a plan to add resources for a private VPC and subnets specifically designed for a Kubernetes cluster.

## Current State Analysis

The existing networking module is primarily focused on:
- Creating static IP addresses for subdomains
- (Commented out) DNS zone and record creation

## Implementation Plan

I'll add the following components to create a private VPC and subnets for a Kubernetes cluster:

### 1. Update Variables

Add new variables in `variables.tf` for:
- VPC configuration (name, auto-create subnetworks flag, routing mode)
- Subnet configurations (names, CIDR ranges, private Google access, secondary IP ranges for pods and services)
- Firewall rules configuration

### 2. Add VPC Resources

Add to `main.tf`:
- `google_compute_network` resource for the VPC
- Network firewall rules for the Kubernetes cluster

### 3. Add Subnet Resources

Add to `main.tf`:
- `google_compute_subnetwork` resources for the Kubernetes cluster
- Configure secondary IP ranges for Kubernetes pods and services

### 4. Update Outputs

Add to `outputs.tf`:
- VPC details (ID, self_link, name)
- Subnet details (IDs, CIDR ranges, secondary ranges)

### 5. Integration with Existing Resources

Ensure the new VPC and subnet resources work alongside the existing static IP resources.

## Proposed Architecture

```mermaid
graph TD
    VPC[VPC: Private Network] --> Subnet1[Primary Subnet: Nodes]
    VPC --> Subnet2[Secondary Subnet: Optional]
    Subnet1 --> SecRange1[Secondary Range: Pods]
    Subnet1 --> SecRange2[Secondary Range: Services]
    VPC --> FW[Firewall Rules]
    FW --> FW1[Allow internal traffic]
    FW --> FW2[Allow health checks]
    FW --> FW3[Allow API server]
```

## Code Changes

I'll need to modify:
1. `variables.tf` - Add new variables
2. `main.tf` - Add VPC and subnet resources
3. `outputs.tf` - Add new outputs
