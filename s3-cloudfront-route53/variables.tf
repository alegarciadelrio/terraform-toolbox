variable "bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  type        = string
  default     = "domain.com"
}

variable "domain_name" {
  description = "The domain name to use for the website"
  type        = string
  default     = "domain.com"
}

variable "zone_id" {
  description = "The Route53 hosted zone ID for the domain"
  type        = string
  default     = "zone-id"
}

variable "alternate_domain_names" {
  description = "List of alternate domain names for CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
  default     = ""
}