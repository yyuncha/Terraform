output s3 {
    description = "The s3 bucket"
    value = module.cloudfront.s3
}

output cloudfront {
    description = "The cloudfront"
    value = module.cloudfront.cloudfront
}

output route53_record {
    description = "route53_record"
    value = module.cloudfront.route53_record
}