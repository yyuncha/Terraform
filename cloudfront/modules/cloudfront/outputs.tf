output cloudfront {
    description = "The cloudfront"
    value = {
        arn = aws_cloudfront_distribution.s3_distribution[0].arn
        domain_name = aws_cloudfront_distribution.s3_distribution[0].domain_name
    }
}

output route53_record {
    description = "route53_record"
    value = {
        alias = tolist([for alias in aws_route53_record.route53_record[0].alias : alias.name])[0]
        fqdn = aws_route53_record.route53_record[0].fqdn
        zone_id = aws_route53_record.route53_record[0].zone_id
    }
}