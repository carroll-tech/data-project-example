# Infrastructure Management

This directory contains Terraform configurations for provisioning and managing the infrastructure components of the data project.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Terraform Cloud Setup](#terraform-cloud-setup)
- [Google Cloud Service Account Setup](#google-cloud-service-account-setup)
- [Infrastructure Components](#infrastructure-components)
- [Getting Started](#getting-started)

## Prerequisites

- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) (v1.1.0+)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- A Google Cloud Platform account with billing enabled
- A Terraform Cloud account

## Terraform Cloud Setup

Terraform Cloud is used to manage the state and provide a consistent workflow for infrastructure changes.

### 1. Create a Terraform Cloud Account

If you don't already have one, sign up for a Terraform Cloud account at [app.terraform.io](https://app.terraform.io/signup/account).

### 2. Create an Organization

After signing in:

1. Create a new organization or use an existing one
2. Note the organization name as it will be used in Terraform configurations

### 3. Create Workspaces

Create the following workspaces in your Terraform Cloud organization:

1. `data-project-example-networking` - For VPC and network resources
2. `data-project-example-cluster` - For GKE cluster resources
3. `data-project-example-argo-cd` - For ArgoCD installation and configuration

For each workspace:

1. Go to "Workspaces" and click "New Workspace"
2. Select "API-driven workflow"
3. Enter the workspace name and click "Create workspace"
4. In the workspace settings, set the Terraform Working Directory to the corresponding subdirectory (e.g., `infrastructure/networking`)

### 4. Configure Variables

For each workspace, set the following variables:

1. Go to the workspace
2. Navigate to "Variables"
3. Add the following environment variables:
   - `GOOGLE_CREDENTIALS` (mark as sensitive) - The JSON content of your Google service account key

### 5. Configure Terraform CLI

1. Generate a user API token in Terraform Cloud:
   - Go to User Settings > Tokens
   - Click "Create an API token"
   - Copy the generated token

2. Configure the Terraform CLI to use this token:

```bash
terraform login
```

When prompted, paste your API token.

## Google Cloud Service Account Setup

### 1. Create a Google Cloud Project

If you don't already have a project:

```bash
gcloud projects create PROJECT_ID --name="Project Name"
gcloud config set project PROJECT_ID
```

### 2. Enable Required APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable iam.googleapis.com
```

### 3. Create a Service Account for Terraform

```bash
# Create the service account
gcloud iam service-accounts create terraform \
  --display-name="Terraform Service Account"
```

### 4. Grant Minimum Required Permissions

#### For Networking Resources

The networking module primarily creates static IP addresses. Grant the minimum required permissions:

```bash
# Grant Compute Network Admin role for managing networking resources
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.networkAdmin"
```

This role includes the necessary permissions to:
- Create and manage static IP addresses (compute.addresses.*)
- View network resources (compute.networks.*)

#### For Cluster Resources

If you plan to apply the cluster resources, additional permissions will be needed:

```bash
# Grant GKE Admin role for creating and managing GKE clusters
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

# Grant Service Account User role to allow the service account to act as other service accounts
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Grant Service Account Admin role to create and manage service accounts
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountAdmin"
```

### 5. Create and Download a Key

```bash
# Create and download a key
gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform@PROJECT_ID.iam.gserviceaccount.com
```

### 6. Upload Service Account Key to Terraform Cloud

1. Open the `terraform-key.json` file
2. Copy its contents
3. In Terraform Cloud, add this as the `GOOGLE_CREDENTIALS` environment variable for each workspace (mark as sensitive)

## Infrastructure Components

The infrastructure is divided into the following components:

- **Networking** (`/networking`): Static IP addresses for services
- **Cluster** (`/cluster`): Google Kubernetes Engine (GKE) cluster
- **ArgoCD** (`/argo-cd`): ArgoCD installation and configuration

## Getting Started

To initialize and apply the infrastructure:

1. Navigate to the networking directory:

```bash
cd infrastructure/networking
terraform init
terraform apply
```

2. After networking is set up, deploy the cluster:

```bash
cd ../cluster
terraform init
terraform apply
```

3. Finally, deploy ArgoCD:

```bash
cd ../argo-cd
terraform init
terraform apply
```

Each component's Terraform configuration is designed to work with Terraform Cloud for state management and collaboration.

## Troubleshooting

If you encounter issues with permissions, ensure that:

1. The service account has the necessary IAM roles for the specific component you're deploying
2. The `GOOGLE_CREDENTIALS` environment variable in Terraform Cloud contains the valid service account key
3. All required Google Cloud APIs are enabled

For Terraform Cloud issues, check that:

1. Your API token is valid
2. The workspace configurations are correct
3. The working directory paths match your repository structure
