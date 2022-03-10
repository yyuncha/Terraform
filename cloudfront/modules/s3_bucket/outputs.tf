output s3 {
    description = "The s3 bucket"
    value = {
        arn = aws_s3_bucket.s3_bucket.arn
        bucket_domain_name = aws_s3_bucket.s3_bucket.bucket_domain_name
        id = aws_s3_bucket.s3_bucket.id
    }
}