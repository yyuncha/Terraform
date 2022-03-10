module "cloudfront" {
    source              = "../"

    # S3
    bucket              = "s3-shinhan-automation-code-20210520"
    acl                 = "public-read"

    target_bucket       = "access-logging-794410467178-ap-northeast-2" 
    target_prefix       = "s3-shinhan-automation-code-20210520" 

    s3_tags                = {
        Name      = "s3-shinhan-automation-code-20210520"
        project   = "pilot"
    }
    
    website_index_document  = "index.html"
    upload_object_path      = "index.html"
    object_acl              = "public-read"
    content_type            = "text/html"

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
    
    # Cloudfront
    aliases         = ["cdn.shinhans.tk"]
    hosted_zone     = "shinhans.tk"

    comment             = "Cloudfront test"
    enabled             = true
    is_ipv6_enabled     = true
    price_class         = "PriceClass_All"
    retain_on_delete    = false
    wait_for_deployment = false
    default_root_object = "index.html"
    cdn_tags     = {
        Name      = "cloudfront-test-setting"
        project   = "pilot"
    }

    create_origin_access_identity = true
    origin_access_identities = {
        s3_bucket_test = "My CloudFront can access"
    }

    logging_config = {
        bucket = "access-logging-794410467178-ap-northeast-2.s3.amazonaws.com"
    }

    origin = {
        s3_test = {
            domain_name = "s3-shinhan-automation-code-20210520.s3.amazonaws.com"
            origin_id = "s3_test"
            s3_origin_config = {
                origin_access_identity = "s3_bucket_test"
            }
        }
    }
 
    default_cache_behavior = {
        target_origin_id       = "s3_test"
        viewer_protocol_policy = "allow-all"

        allowed_methods = ["GET", "HEAD", "OPTIONS"]
        cached_methods  = ["GET", "HEAD"]
        compress        = true
        query_string    = true
    }

    ordered_cache_behavior = [
        {
            path_pattern           = "/static/*"
            target_origin_id       = "s3_test"
            viewer_protocol_policy = "redirect-to-https"

            allowed_methods = ["GET", "HEAD", "OPTIONS"]
            cached_methods  = ["GET", "HEAD"]
            compress        = true
            query_string    = true
        }
    ]

    viewer_certificate = {
        acm_certificate_arn = "arn:aws:acm:us-east-1:794410467178:certificate/c72c5a67-5126-47e1-86fc-e282da487503"
        ssl_support_method  = "sni-only"
    }
}