resource "aws_route53_record" "route53_record" {
    count       = length(var.aliases)
    zone_id     = data.aws_route53_zone.domain_name.zone_id
    name        = var.aliases[count.index]
    type        = "A"

    alias {
        name    = aws_cloudfront_distribution.s3_distribution[0].domain_name
        zone_id = aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id

        evaluate_target_health = false
    }

    depends_on = [
        aws_cloudfront_distribution.s3_distribution
    ]
}