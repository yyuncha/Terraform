resource "aws_acm_certificate" "gitlab_acm_cert" {
  domain_name       = "*.${var.gitlab_domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "gitlab_route_zone" {
  name = var.gitlab_domain_name
}


resource "aws_route53_record" "gitlab_route_record" {
  for_each = {
    for dvo in aws_acm_certificate.gitlab_acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = aws_route53_zone.gitlab_route_zone.zone_id
  ttl             = 60
}
resource "aws_route53_record" "gitlab_route_record2" {
  zone_id = aws_route53_zone.gitlab_route_zone.zone_id
  name    = var.gitlab_host_name
  type    = "A"

  alias {
    name                   = aws_lb.gitlab_lb.dns_name
    zone_id                = aws_lb.gitlab_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "gitlab_acm_cert_valid" {
  certificate_arn         = aws_acm_certificate.gitlab_acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.gitlab_route_record : record.fqdn]
}
