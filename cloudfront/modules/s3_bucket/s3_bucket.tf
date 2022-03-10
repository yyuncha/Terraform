resource "aws_s3_bucket" "s3_bucket" {
    bucket          = var.bucket   # bucket명
    acl             = var.acl    # acl 지정
    
    # versioning 활성화 여부
    versioning {  enabled = var.versioning }

    # logging target bucket 지정 및 prefix 값 지정
    dynamic "logging" {
        for_each = var.target_bucket == null ? [] : [true]
        content {
            target_bucket   = var.target_bucket
        target_prefix   = "${var.target_prefix}/${data.aws_caller_identity.current.account_id}/${data.aws_region.current.name}/${var.bucket}/"
        }
    }

    # s3 server side 암호화 지정 (static web site)
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm       = "AES256"
            }
        }
    }

    tags = var.tags

    force_destroy       = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
    bucket = aws_s3_bucket.s3_bucket.id

    # bucket에 대해 public access block 지정 (acl, policy)
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets = var.restrict_public_buckets

    depends_on = [
        aws_s3_bucket.s3_bucket
    ]
}