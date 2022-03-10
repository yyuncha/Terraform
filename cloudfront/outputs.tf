output s3 {
    description = "The s3 bucket"
    value = module.s3_bucket.s3
}

output cloudfront {
    description = "The cloudfront"
    value = module.cdn.cloudfront
}

output route53_record {
    description = "route53_record"
    value = module.cdn.route53_record
}