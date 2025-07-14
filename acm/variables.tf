variable "domain_name" {
  description = "The domain name for the SSL certificate"
  type        = string
}

variable "route53_zone_name" {
  description = "The name of the Route53 hosted zone to use for DNS validation"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "Additional domain names (SANs) for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "The method to use for validation (DNS or EMAIL)"
  type        = string
  default     = "DNS"
  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "validation_method must be either 'DNS' or 'EMAIL'"
  }
}

variable "tags" {
  description = "A map of tags to add to the certificate"
  type        = map(string)
  default     = {}
}
