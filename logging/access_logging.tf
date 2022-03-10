# s3 & ELB access logging bucket for each member account
# Do not apply block public access!!
# access logs are not replicated to central logs
data "aws_elb_service_account" "elb_service_account" {}

resource "aws_s3_bucket" "access_logging_bucket" {
  bucket        = "access-logging-${var.shared_account_id}-${var.aws_region}"
  acl           = "log-delivery-write"
  force_destroy = true
  depends_on    = [aws_s3_bucket_public_access_block.public_access_block]

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
            "Sid": "ELB account owner",
            "Effect": "Allow",
            "Principal": {
            "AWS": "${data.aws_elb_service_account.elb_service_account.arn}"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::access-logging-${var.shared_account_id}-${var.aws_region}/*"
        },
        {
            "Sid": "account owner",
            "Effect": "Allow",
            "Principal": {
            "AWS": "arn:aws:iam::${var.shared_account_id}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::access-logging-${var.shared_account_id}-${var.aws_region}/*"
        },
        {
            "Sid": "Require SSL",
            "Effect": "Deny",
            "Principal": {
              "AWS": "*"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::access-logging-${var.shared_account_id}-${var.aws_region}/*",
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
            "Resource": "arn:aws:s3:::access-logging-${var.shared_account_id}-${var.aws_region}/*",
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
            "Resource": "arn:aws:s3:::access-logging-${var.shared_account_id}-${var.aws_region}"
        }
    ]
}
POLICY

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = var.s3_access_log_lifecycle_name
    enabled = var.s3_access_log_lifecycle_enabled

    prefix = "${var.s3_access_log_prefix}/"

    noncurrent_version_expiration {
      days = var.s3_access_log_noncurrent_version_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.s3_access_log_enable_glacier_transition ? [1] : []

      content {
        days          = var.s3_access_log_noncurrent_version_transition_days
        storage_class = "GLACIER"
      }
    }

    transition {
      days          = var.s3_access_log_standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.s3_access_log_enable_glacier_transition ? [1] : []

      content {
        days          = var.s3_access_log_glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.s3_access_log_expiration_days
    }
  }

  lifecycle_rule {
    id      = var.elb_access_log_lifecycle_rule_name
    enabled = var.elb_access_log_lifecycle_rule_enabled

    prefix = "${var.elb_access_log_prefix}/"

    noncurrent_version_expiration {
      days = var.elb_access_log_noncurrent_version_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.elb_access_log_enable_glacier_transition ? [1] : []

      content {
        days          = var.elb_access_log_noncurrent_version_transition_days
        storage_class = "GLACIER"
      }
    }

    transition {
      days          = var.elb_access_log_standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.elb_access_log_enable_glacier_transition ? [1] : []

      content {
        days          = var.elb_access_log_glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.elb_access_log_expiration_days
    }
  }
}
# For SSM Parameter Group of S3 Logging Bucket
resource "aws_ssm_parameter" "ssm_s3_logging_bucket_id" {
  name      = "/s3/s3LoggingBucketId"
  type      = "SecureString"
  overwrite = true
  value     = aws_s3_bucket.access_logging_bucket.id
  tags = {
    "build:type" = "aws_ssm_parameter"
    "build:name" = "s3_logging_bucket_id"
  }
}

resource "aws_ssm_parameter" "ssm_s3_logging_bucket_arn" {
  name      = "/s3/s3LoggingBucketArn"
  type      = "SecureString"
  overwrite = true
  value     = aws_s3_bucket.access_logging_bucket.arn
  tags = {
    "build:type" = "aws_ssm_parameter"
    "build:name" = "s3_logging_bucket_id"
  }
}

resource "aws_s3_bucket_public_access_block" "access_logging_bucket_public_access_block" {
  bucket = aws_s3_bucket.access_logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
