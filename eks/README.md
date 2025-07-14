# EKS Cluster with Cross-Account Access Terraform Module

This Terraform module creates an Amazon EKS (Elastic Kubernetes Service) cluster and grants management permissions to another AWS account. This enables cross-account management of the EKS cluster, which is useful for organizations with multiple AWS accounts.

## Architecture

This module sets up:

1. A VPC with public and private subnets across multiple availability zones
2. An EKS cluster in the private subnets
3. A managed node group for the EKS cluster
4. IAM roles and policies for the EKS cluster and node group
5. A cross-account IAM role that grants EKS management permissions to another AWS account

## Prerequisites

Before using this module, you need:

1. AWS CLI installed and configured with appropriate credentials
2. Terraform (version 1.0.0 or newer)
3. The AWS account ID of the external account that will be granted management access
4. Sufficient permissions to create all the resources defined in this module

## Usage

### 1. Configure Variables

Copy the example variables file and modify it for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to set your specific values:
- Set the AWS region
- Choose a unique cluster name
- Configure the VPC settings
- Set the Kubernetes version
- Configure the node group settings
- **Important**: Replace the example `external_account_id` with the actual AWS account ID that needs access to the EKS cluster

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

## Cross-Account Access

This module creates an IAM role (`<cluster_name>-cross-account-admin-role`) that can be assumed by the specified external AWS account. This role has permissions to:

- Describe and list EKS clusters
- Describe and list node groups
- Access the Kubernetes API server
- List and describe Fargate profiles and add-ons

### Configuring kubectl for Cross-Account Access

After the EKS cluster is created, users in the external account can configure kubectl to access the cluster by assuming the cross-account role:

```bash
# Assume the cross-account role
aws sts assume-role --role-arn <cross_account_role_arn> --role-session-name EKSAccess

# Set the temporary credentials
export AWS_ACCESS_KEY_ID=<from the output above>
export AWS_SECRET_ACCESS_KEY=<from the output above>
export AWS_SESSION_TOKEN=<from the output above>

# Update kubeconfig
aws eks update-kubeconfig --region <aws_region> --name <cluster_name>
```

The `cross_account_kubectl_config_command` output provides the exact command to use.

### Granting Additional Kubernetes RBAC Permissions

By default, the cross-account role has limited permissions in Kubernetes RBAC. To grant additional permissions, you need to update the `aws-auth` ConfigMap in the EKS cluster.

After the cluster is created, run:

```bash
kubectl edit configmap aws-auth -n kube-system
```

Add the following entry to the `mapRoles` section:

```yaml
- rolearn: <cross_account_role_arn>
  username: cross-account-admin
  groups:
    - system:masters
```

Replace `<cross_account_role_arn>` with the ARN of the cross-account role (available in the Terraform outputs).

## Outputs

This module provides several useful outputs:

- `cluster_endpoint`: The endpoint for the Kubernetes API server
- `cluster_certificate_authority_data`: The certificate authority data for the cluster
- `cross_account_role_arn`: The ARN of the cross-account IAM role
- `kubectl_config_command`: Command to update kubeconfig for the created EKS cluster
- `cross_account_kubectl_config_command`: Command to update kubeconfig using the cross-account role

## Security Considerations

1. The cross-account role follows the principle of least privilege, granting only the necessary permissions.
2. The EKS cluster API server endpoint can be configured to be private or public.
3. The VPC is configured with private subnets for the EKS nodes, with NAT gateways for outbound internet access.
4. All resources are tagged for better resource management.

## Customization

You can customize this module by:

1. Modifying the IAM policies to grant more or fewer permissions
2. Adding additional node groups with different configurations
3. Configuring Kubernetes add-ons
4. Implementing more advanced networking features

## Troubleshooting

Common issues:

1. **Access Denied Errors**: Verify that the IAM roles and policies are correctly configured.
2. **AssumeRole Failures**: Ensure the trust relationship is properly set up.
3. **kubectl Access Issues**: Make sure the aws-auth ConfigMap is properly configured.
4. **Networking Issues**: Check that the VPC, subnets, and security groups are properly configured.

## License

This Terraform module is released under the MIT License.