# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
  # The primary account credentials are used by default
}

# S3 bucket in your account
resource "aws_s3_bucket" "shared_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "Multi-tenant data sharing"
  }
}

# Block public access for the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.shared_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy allowing other tenants to access your bucket
resource "aws_s3_bucket_policy" "allow_other_tenants" {
  bucket = aws_s3_bucket.shared_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowOtherTenantsAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.other_tenants_principal_arns
        }
        Action = var.other_tenants_allowed_actions
        Resource = [
          aws_s3_bucket.shared_bucket.arn,
          "${aws_s3_bucket.shared_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Optional: Configure bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.shared_bucket.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Optional: Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.shared_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}