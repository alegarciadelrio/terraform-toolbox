# Multi-Tenant S3 Bucket Sharing Terraform Module

This Terraform module creates an S3 bucket that can be securely shared with multiple AWS accounts (tenants), allowing for controlled cross-account data sharing.

## Architecture

This module sets up:

1. An S3 bucket in your AWS account
2. Bucket policies that allow controlled access from other tenant accounts
3. Proper security configurations including:
   - Blocking public access
   - Server-side encryption
   - Optional versioning

## Prerequisites

Before using this module, you need to:

1. Have AWS credentials configured for your account
2. Identify the AWS accounts (tenants) you want to share your bucket with
3. Obtain the IAM role/user ARNs from those accounts that will need access

## Setup Instructions

### 1. Configure Variables

Copy the example variables file and modify it for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to set your specific values:
- Set a unique bucket name
- Replace the example tenant account IDs with the actual AWS account IDs you want to share with
- Configure the appropriate IAM role/user ARNs and permissions

Example:
```hcl
# Bucket name - must be globally unique
bucket_name = "your-shared-data-bucket"

# List of ARNs from other tenants that need access to your bucket
other_tenants_principal_arns = [
  "arn:aws:iam::123456789012:role/S3AccessRole",
  "arn:aws:iam::234567890123:role/S3AccessRole",
  "arn:aws:iam::345678901234:user/s3-user"
]
```

### 2. Initialize and Apply

Initialize the Terraform configuration:

```bash
terraform init
```

Review the plan:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

## Usage Examples

### Accessing your shared bucket from other tenant accounts

After applying this Terraform configuration, users from other tenant accounts can access your bucket using the AWS CLI:

```bash
# Using credentials from the other tenant account
aws s3 ls s3://your-shared-data-bucket
```

### Using the shared bucket in application code

In application code running in other tenant accounts, they can use the AWS SDK to access your shared bucket:

```python
import boto3

# Using credentials from the other tenant account
s3_client = boto3.client('s3')
response = s3_client.list_objects_v2(Bucket='your-shared-data-bucket')
```

## Security Considerations

1. **Principle of Least Privilege**: The bucket policy is configured to grant only the necessary permissions to other tenants.
2. **Encryption**: Server-side encryption is enabled by default.
3. **Public Access**: The bucket has public access blocked.
4. **Versioning**: Bucket versioning is enabled by default to protect against accidental deletions.

## Customization

You can customize this module by:

1. Modifying the bucket policy to add more granular permissions
2. Adding additional S3 bucket configurations like lifecycle policies
3. Implementing more advanced security features like VPC endpoints

## Troubleshooting

Common issues:

1. **Access Denied Errors**: Verify that the IAM roles/users and bucket policy are correctly configured.
2. **Bucket Already Exists**: S3 bucket names must be globally unique; try a different name.
3. **Permission Issues**: Ensure the other tenant accounts have the necessary permissions to access your bucket.

## License

This Terraform module is released under the MIT License.