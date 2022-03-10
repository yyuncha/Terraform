#data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "aws_cloudtrails" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.source_log_bucket.id
  s3_key_prefix                 = var.cloudtrail_prefix
  cloud_watch_logs_role_arn     = aws_iam_role.iam_role_cloudtrail.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudwatch_log_group_cloudtrail.arn}:*"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  depends_on = [aws_iam_role_policy.iam_role_policy_lambda,  aws_cloudwatch_log_group.cloudwatch_log_group_cloudtrail]
}
resource "aws_s3_bucket" "source_log_bucket" {
  bucket        = "core-logging-${var.shared_account_id}-${var.aws_region}" #S3 Bucket Naming rule
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  #region = var.aws_region
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [

        {
            "Sid": "CloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::core-logging-${var.shared_account_id}-${var.aws_region}"
        },
        {
            "Sid": "CloudTrailWrite",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::core-logging-${var.shared_account_id}-${var.aws_region}/*"
        },
        {
            "Sid": "Require SSL",
            "Effect": "Deny",
            "Principal": {
              "AWS": "*"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::core-logging-${var.shared_account_id}-${var.aws_region}/*",
            "Condition": {
              "Bool": {
                "aws:SecureTransport": "false"
              }
            }
         },
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::core-logging-${var.shared_account_id}-${var.aws_region}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::core-logging-${var.shared_account_id}-${var.aws_region}"
        }
    ]
}
POLICY

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = var.cloudtrail_lifecycle_rule_name
    enabled = var.cloudtrail_lifecycle_rule_enabled

    prefix = "${var.cloudtrail_prefix}/"

    noncurrent_version_expiration {
      days = var.cloudtrail_noncurrent_version_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.cloudtrail_enable_glacier_transition ? [1] : []

      content {
        days          = var.cloudtrail_noncurrent_version_transition_days
        storage_class = "GLACIER"
      }
    }

    transition {
      days          = var.cloudtrail_standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.cloudtrail_enable_glacier_transition ? [1] : []

      content {
        days          = var.cloudtrail_glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.cloudtrail_expiration_days
    }
  }

  lifecycle_rule {
    id      = var.flowlogs_lifecycle_rule_name
    enabled = var.flowlogs_lifecycle_rule_enabled

    prefix = "${var.flowlogs_prefix}/"

    noncurrent_version_expiration {
      days = var.flowlogs_noncurrent_version_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.flowlogs_enable_glacier_transition ? [1] : []

      content {
        days          = var.flowlogs_noncurrent_version_transition_days
        storage_class = "GLACIER"
      }
    }

    transition {
      days          = var.flowlogs_standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.flowlogs_enable_glacier_transition ? [1] : []

      content {
        days          = var.flowlogs_glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.flowlogs_expiration_days
    }
  }


}
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_cloudtrail" {
  name              = var.cloudwatch_log_group_cloudtrail_name
  retention_in_days = "30"
}
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_flowlogs" {
  #count             = length(var.vpc_id)
  name              = "${var.cloudwatch_log_group_flowlogs_name}-${var.vpc_id}" # ${var.flowlogs_log_group_name} Default Value is FLOWLOGS_LOG_GROUP
  retention_in_days = 30
}
resource "aws_flow_log" "aws_flowlogs_cloudwatch" {
  #count           = length(var.vpc_id)
  iam_role_arn    = aws_iam_role.iam_role_flowlogs.arn
  log_destination = aws_cloudwatch_log_group.cloudwatch_log_group_flowlogs.arn #log group2 is FLOWLOGS_LOG_GROUP-Secondary_vpc_id
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}
resource "aws_flow_log" "aws_flowlogs" {
  #count                = length(var.vpc_id)
  log_destination      = "${aws_s3_bucket.source_log_bucket.arn}/${var.flowlogs_prefix}/${var.vpc_id}/" #Specific Path for Logging | ${var.vpcflowlogs_prefix} = VPCFlowLogs
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
}
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.source_log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket${var.shared_account_id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.copy_func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_log_bucket.arn
}
resource "aws_lambda_function" "copy_func" {
  filename      = "${path.module}/files/lambda_copy.zip"
  function_name = "copy-logs-lambda"
  role          = aws_iam_role.iam_role_lambda.arn
  handler       = "lambda_copy.lambda_handler"
  runtime       = "python3.6"

  environment {
    variables = {
      destination_bucket = var.central_logging_bucket
    }
  }
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_log_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.copy_func.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
