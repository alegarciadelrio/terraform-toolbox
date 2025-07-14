resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation record (only created if validation_method is DNS)
resource "aws_route53_record" "validation" {
  count = var.validation_method == "DNS" ? 1 : 0

  name    = element(aws_acm_certificate.certificate.domain_validation_options[*].resource_record_name, 0)
  type    = element(aws_acm_certificate.certificate.domain_validation_options[*].resource_record_type, 0)
  zone_id = data.aws_route53_zone.zone[0].id
  records = [element(aws_acm_certificate.certificate.domain_validation_options[*].resource_record_value, 0)]
  ttl     = 60
}

data "aws_route53_zone" "zone" {
  count = var.validation_method == "DNS" ? 1 : 0

  name = var.route53_zone_name
}
