data "aws_route53_zone" "domain_name" {
    name         = var.hosted_zone
    private_zone = false
}

data "aws_iam_policy_document" "s3_policy" {
    dynamic "statement" {
        for_each = aws_cloudfront_origin_access_identity.this
        content {
            actions   = ["s3:GetObject"]
            resources = ["${var.s3_arn}/*"]

            principals {
                type        = "AWS"
                identifiers = [aws_cloudfront_origin_access_identity.this[statement.key].iam_arn]
            }
        }
    }

    dynamic "statement" {
        for_each = aws_cloudfront_origin_access_identity.this
        content {
            actions   = ["s3:ListBucket"]
            resources = [var.s3_arn]

            principals {
                type        = "AWS"
                identifiers = [aws_cloudfront_origin_access_identity.this[statement.key].iam_arn]
            }
        }
    }

    depends_on = [
        aws_cloudfront_origin_access_identity.this
    ]
}
