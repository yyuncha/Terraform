
output "source_log_bucket_name" {
  value = aws_s3_bucket.source_log_bucket.id
}
output "source_log_bucket_arn" {
  value = aws_s3_bucket.source_log_bucket.arn
}
output "access_log_bucket_name" {
  value = aws_s3_bucket.access_logging_bucket.id
}
output "access_log_bucket_arn" {
  value = aws_s3_bucket.access_logging_bucket.arn
}
output "lambda_s3_replication_iam_role_arn" {
  value = aws_iam_role.iam_role_lambda.arn
}
output "s3_access_logging_prefix" {
  value = var.s3_access_log_prefix
}
