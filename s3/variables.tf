variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to be shared with other tenants"
  type        = string
}

variable "other_tenants_principal_arns" {
  description = "List of ARNs from other tenants that need access to your bucket"
  type        = list(string)
}

variable "other_tenants_allowed_actions" {
  description = "List of S3 actions other tenants are allowed to perform on your bucket"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket"
  ]
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}