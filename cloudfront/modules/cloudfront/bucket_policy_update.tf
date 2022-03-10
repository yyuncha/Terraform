resource "aws_s3_bucket_policy" "s3_bucket_policy" {
    bucket  = var.s3_id
    policy = data.aws_iam_policy_document.s3_policy.json
}