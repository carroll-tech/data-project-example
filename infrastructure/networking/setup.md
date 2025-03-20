# Required Setup for Networking Module

Before running `terraform apply` for the networking module, you need to enable the following Google Cloud APIs in your project and ensure the proper permissions are set up.

## Required Google Cloud APIs

The following APIs need to be enabled in your project:

1. **Identity-Aware Proxy API (iap.googleapis.com)**:
   ```bash
   gcloud services enable iap.googleapis.com --project=data-project-example
   ```

2. **Workload Identity Federation API (iam.googleapis.com)**:
   ```bash
   gcloud services enable iam.googleapis.com --project=data-project-example
   ```

3. **Compute Engine API (compute.googleapis.com)**:
   ```bash
   gcloud services enable compute.googleapis.com --project=data-project-example
   ```

4. **Cloud Resource Manager API (cloudresourcemanager.googleapis.com)**:
   ```bash
   gcloud services enable cloudresourcemanager.googleapis.com --project=data-project-example
   ```

5. **Service Account Credentials API (iamcredentials.googleapis.com)**:
   ```bash
   gcloud services enable iamcredentials.googleapis.com --project=data-project-example
   ```

### Enabling All Required APIs at Once

You can enable all required APIs with a single command:

```bash
gcloud services enable \
  iap.googleapis.com \
  iam.googleapis.com \
  compute.googleapis.com \
  cloudresourcemanager.googleapis.com \
  iamcredentials.googleapis.com \
  --project=data-project-example
```

### Verifying API Enablement

To verify that the APIs have been enabled:

```bash
gcloud services list --enabled --filter="name:iap.googleapis.com OR name:iam.googleapis.com OR name:compute.googleapis.com OR name:cloudresourcemanager.googleapis.com OR name:iamcredentials.googleapis.com" --project=data-project-example
```

## Required Permissions

The account running Terraform needs the following permissions:

1. `roles/iam.workloadIdentityPoolAdmin` - To create and manage Workload Identity Pools
2. `roles/iam.serviceAccountAdmin` - To create and manage service accounts
3. `roles/compute.networkAdmin` - To create and manage network resources
4. `roles/compute.securityAdmin` - To create and manage firewall rules
5. `roles/iap.admin` - To configure Identity-Aware Proxy

You can grant these roles to your account with:

```bash
gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/iam.workloadIdentityPoolAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/iam.serviceAccountAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/compute.securityAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/iap.admin
```

Replace `YOUR_EMAIL` with your Google Cloud account email.

## Terraform Cloud Service Account

If you're using Terraform Cloud, make sure the service account has the necessary permissions:

```bash
gcloud projects add-iam-policy-binding data-project-example \
  --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
  --role=roles/iam.workloadIdentityPoolAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
  --role=roles/iam.serviceAccountAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
  --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
  --role=roles/compute.securityAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
  --role=roles/iap.admin
```

Replace `TERRAFORM_CLOUD_SA_EMAIL` with the email of the service account used by Terraform Cloud.

## SSL Certificate Limitations

Google-managed SSL certificates have the following limitations:

1. **No Wildcard Support**: Google-managed SSL certificates do not support wildcard domains (e.g., `*.example.com`). Each subdomain needs its own certificate.

2. **Domain Verification**: You need to verify ownership of the domain before creating certificates.

3. **Provisioning Time**: It can take up to 24 hours for a certificate to be fully provisioned.

## GitHub OAuth Setup

For IAP authentication with GitHub, you need to:

1. Create a GitHub OAuth application
2. Configure the callback URL to point to IAP
3. Add the client ID and secret to Terraform Cloud variables

See the main README.md for detailed instructions on GitHub OAuth setup.
