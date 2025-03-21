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

6. **Cloud DNS API (dns.googleapis.com)**:
   ```bash
   gcloud services enable dns.googleapis.com --project=data-project-example
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
  dns.googleapis.com \
  --project=data-project-example
```

### Verifying API Enablement

To verify that the APIs have been enabled:

```bash
gcloud services list --enabled --filter="name:iap.googleapis.com OR name:iam.googleapis.com OR name:compute.googleapis.com OR name:cloudresourcemanager.googleapis.com OR name:iamcredentials.googleapis.com OR name:dns.googleapis.com" --project=data-project-example
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
    
     - **Important Clarification**: When selecting "Internal" for the User Type:
       - This setting only applies to the Google OAuth consent screen configuration
       - It does NOT restrict authentication to users with organization email addresses
       - Since authentication is handled by GitHub, users will authenticate with their GitHub accounts
       - Access control is based on GitHub repository roles, not Google Workspace organization membership
       - The "Internal" setting simply allows you to avoid the verification process while maintaining the security benefits
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
8. `roles/dns.admin` - To manage DNS records
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

## Single Entry Point Architecture with Cloud DNS

The refactored networking module uses a single entry point with Cloud DNS for all domains and subdomains:

### SSL Certificate with Multiple Domains

The architecture uses a single Google-managed SSL certificate that covers:
- The root domain (data-project-example.net)
- Explicit subdomains (cd.data-project-example.net)
- Wildcard domain (*.data-project-example.net) if enabled

Note that Google-managed SSL certificates have some limitations:
- Provisioning Time: It can take up to 24 hours for a certificate to be fully provisioned
- Maximum of 100 domains per certificate
- For SAN certificates (not wildcard), each subdomain must be explicitly listed

### Cloud DNS Configuration

Cloud DNS fully supports wildcard records, making it ideal for our single entry point architecture:

1. **DNS Zone Creation**: 
   - The module automatically creates a Cloud DNS zone for your domain
   - The zone handles all DNS records for your domain and subdomains

2. **Record Types**:
   - Root A Record: Points `data-project-example.net` to the single IP
   - Subdomain A Records: Points specific subdomains to the same IP
   - Wildcard A Record: Points `*.data-project-example.net` to the same IP

3. **Wildcard Support in Cloud DNS**:
   - Cloud DNS fully supports wildcard records (*.example.com)
   - This allows any subdomain to automatically resolve to your single IP
   - Specific subdomains can override the wildcard behavior with their own records
   - You can even create nested wildcards (*.subdomain.example.com)

4. **Retrieving DNS Information**:
   ```bash
   # Get the main IP address
   MAIN_IP=$(terraform output -raw main_ip_address)
   
   # Get DNS information including nameservers
   DNS_INFO=$(terraform output -json cloud_dns)
   ```

5. **Domain Registrar Configuration**:
   - After creating the Cloud DNS zone, you need to update your domain registrar to use Google Cloud DNS nameservers
   - Get the nameservers from the terraform output:
     ```bash
     echo $DNS_INFO | jq -r '.name_servers[]'
     ```
   - Go to your domain registrar (e.g., GoDaddy, Namecheap, etc.)
   - Update the nameservers to the ones provided by Cloud DNS
   - Wait for propagation (can take up to 48 hours, but usually much faster)

6. **Verifying DNS Setup**:
   ```bash
   # Check if DNS records are propagated
   dig data-project-example.net
   dig cd.data-project-example.net
   dig random-subdomain.data-project-example.net  # Should resolve if wildcard is enabled
   ```

## GitHub OAuth Setup

For IAP authentication with GitHub, you need to:

1. Create a GitHub OAuth application
2. Configure the callback URL to point to IAP
3. Add the client ID and secret to Terraform Cloud variables

See the main README.md for detailed instructions on GitHub OAuth setup.

## Registering Your Domain with Google Search Console

When using Cloud DNS, registering with Google Search Console is simpler:

### Prerequisites

- A Google account
- Your domain properly configured in Cloud DNS
- DNS verification completed (nameservers updated at registrar)

### Step 1: Access Google Search Console

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Sign in with your Google account
3. Click "Add property" to begin the registration process

### Step 2: Choose Property Type

1. Select "Domain" as the property type (recommended)
   - This covers all subdomains and protocols (http, https)
2. Enter your domain: `data-project-example.net`

### Step 3: Verify Domain Ownership via DNS Provider

Since you're using Cloud DNS (a Google service), verification is simplified:

1. Google will provide a TXT record for verification
2. If you're in the same Google account that manages your Cloud DNS:
   - You may see an option to verify automatically
   - Click "Verify" if available

3. If manual verification is needed:
   - In Cloud Console, go to Network Services → Cloud DNS
   - Select your domain's DNS zone
   - Add a new record set:
     - DNS Name: @ (for root domain)
     - Resource Record Type: TXT
     - TTL: 3600 (or default)
     - Data: [Verification string provided by Google]
   - Click "Create"
   
4. Return to Google Search Console and click "Verify"
   - Verification should be quicker with Cloud DNS than with third-party DNS providers

### Step 4: Submit Sitemaps and Monitor

1. Create and submit sitemaps for your applications
2. Set up performance monitoring
3. Configure any additional Search Console settings
