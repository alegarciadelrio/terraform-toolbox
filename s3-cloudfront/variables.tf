variable "bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  type        = string
  default     = "static-website"
}

variable "domain_name" {
  description = "The domain name to use for the website"
  type        = string
  default     = "domain.com"
}

variable "zone_id" {
  description = "The domain name to use for the website"
  type        = string
  default     = "zone-id"
}