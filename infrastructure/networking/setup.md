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

## Organization IAP Setup

Now that the project is part of a GCP organization, IAP is enabled by default. This requires additional setup:

### Enable IAP API

Ensure the IAP API is enabled:

```bash
gcloud services enable iap.googleapis.com --project=data-project-example
```

### Manual IAP Brand Creation

1. **Create the IAP Brand in Google Cloud Console**:
   - Go to Google Cloud Console → Security → Identity-Aware Proxy
   - Select your project
   - You'll be prompted to configure the OAuth consent screen:
     - Select "Internal" for the User Type (since the project is part of an organization)
     - Fill in the required information:
       - App name: "Data Project Example"
       - User support email: Your email address
       - Developer contact information: Your email address
     - Add the necessary scopes:
       - `./auth/userinfo.email`
       - `./auth/userinfo.profile`
     - Click **Save** to create the brand

2. **Get the Brand Name**:
   - After creating the brand, look at the URL in your browser
   - The URL will contain something like `brand=brands%2FBRAND_ID`
   - The full brand name will be in the format `projects/PROJECT_NUMBER/brands/BRAND_ID`
   - Alternatively, use the gcloud CLI:
     ```bash
     gcloud iap oauth-brands list --project=YOUR_PROJECT_ID
     ```

3. **Set the Brand Name in Terraform**:
   - Add the brand name to your Terraform Cloud variables:
     - Key: `existing_iap_brand`
     - Value: The brand name in the format `projects/PROJECT_NUMBER/brands/BRAND_ID`
     - Category: Terraform
     - Sensitive: No

4. **Run Terraform Apply Again**:
   - With the brand name set, run `terraform apply` again
   - Terraform will now use the existing brand instead of trying to create a new one

### Configure IAP in Google Cloud Console

After applying the Terraform changes:

1. Go to Google Cloud Console → Security → Identity-Aware Proxy
2. Verify that IAP is enabled for the backend services
3. Check that the OAuth client is properly configured
4. Test access with different organization members

### Troubleshooting IAP Brand Issues

If you encounter issues with the IAP brand:

1. **Verify Brand Format**:
   - Ensure the brand name is in the correct format: `projects/PROJECT_NUMBER/brands/BRAND_ID`
   - The PROJECT_NUMBER is numeric and different from your project ID

2. **Check Permissions**:
   - Ensure your user account has the `roles/iap.admin` role
   - This is required to view and manage IAP brands

3. **Verify Brand Existence**:
   - Use the gcloud CLI to list existing brands:
     ```bash
     gcloud iap oauth-brands list --project=YOUR_PROJECT_ID
     ```
   - If no brands are listed, you may need to create one manually

4. **OAuth Client Creation**:
   - If the brand exists but you're having issues with the OAuth client:
     - You can create the OAuth client manually in the Google Cloud Console
     - Then update the `github_oauth_client_id` and `github_oauth_client_secret` variables

## Required Permissions

The account running Terraform needs the following permissions:

1. `roles/iam.workloadIdentityPoolAdmin` - To create and manage Workload Identity Pools
2. `roles/iam.serviceAccountAdmin` - To create and manage service accounts
3. `roles/iam.securityAdmin` - To manage IAM policies and role bindings
4. `roles/compute.networkAdmin` - To create and manage network resources
5. `roles/compute.securityAdmin` - To create and manage firewall rules
6. `roles/compute.loadBalancerAdmin` - To manage load balancers, backend services, and health checks
7. `roles/iap.admin` - To configure Identity-Aware Proxy
8. `roles/dns.admin` - To manage DNS records if needed
9. `roles/serviceusage.serviceUsageAdmin` - To enable required APIs

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
  --role=roles/iam.securityAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/compute.securityAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/compute.loadBalancerAdmin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/iap.admin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/dns.admin

gcloud projects add-iam-policy-binding data-project-example \
  --member=user:YOUR_EMAIL \
  --role=roles/serviceusage.serviceUsageAdmin
```

Replace `YOUR_EMAIL` with your Google Cloud account email.

## Terraform Cloud Service Account

If you're using Terraform Cloud, make sure the service account has the necessary permissions:

```bash
for ROLE in \
  roles/iam.workloadIdentityPoolAdmin \
  roles/iam.serviceAccountAdmin \
  roles/iam.securityAdmin \
  roles/compute.networkAdmin \
  roles/compute.securityAdmin \
  roles/compute.loadBalancerAdmin \
  roles/iap.admin \
  roles/dns.admin \
  roles/serviceusage.serviceUsageAdmin
do
  gcloud projects add-iam-policy-binding data-project-example \
    --member=serviceAccount:TERRAFORM_CLOUD_SA_EMAIL \
    --role=$ROLE
done
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
