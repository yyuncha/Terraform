resource "aws_s3_bucket_object" "file_upload" {
    bucket          = aws_s3_bucket.s3_bucket.id
    key             = var.website_index_document
    source          = var.upload_object_path
    etag            = filemd5(var.upload_object_path)
    acl             = var.object_acl
    content_type    = var.content_type
    
    depends_on = [
        aws_s3_bucket.s3_bucket
    ]
}