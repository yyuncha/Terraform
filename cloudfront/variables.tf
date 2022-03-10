# S3 bucket static web-site
variable bucket {
    description = "The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be less than or equal to 63 characters in length"
    type = string
}

variable acl {
    description = "The canned ACL to apply."
    type = string
    default = "private"
}

variable versioning {
    description = "A state of versioning"
    type = bool
    default = true
}

variable target_bucket { 
    description = "The name of the bucket that will receive the log objects."
    type = string
    default = null
}

variable target_prefix { 
    description = "To specify a key prefix for log objects."
    type = string
    default = null
}

variable s3_tags {
    description = "A map of tags to assign to the bucket."
    type = map
}

variable force_destroy {
    description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error."
    type = bool
    default = true
}

variable website_index_document {
    description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders."
    type = string
}

variable upload_object_path {
    description = "command to upload index.html file to s3 bucket"
    type = string
}

variable object_acl {
    description = "The canned ACL to apply for object."
    type = string
    default = "private"
}

variable content_type {
    description = "A standard MIME type describing the format of the object data, e.g. application/octet-stream."
    type = string
} 
variable block_public_acls { 
    description = "Whether Amazon S3 should block public ACLs for this bucket."
    type = bool
    default = true
}

variable block_public_policy { 
    description = "Whether Amazon S3 should block public bucket policies for this bucket."
    type = bool
    default = true
}

variable ignore_public_acls { 
    description = "Whether Amazon S3 should ignore public ACLs for this bucket."
    type = bool
    default = true
}

variable restrict_public_buckets { 
    description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
    type = bool
    default = true
}

# Cloudfront
variable create_distribution {
    description = "Controls if CloudFront distribution should be created"
    type        = bool
    default     = true
}

variable create_origin_access_identity {
    description = "Controls if CloudFront origin access identity should be created"
    type        = bool
    default     = false
}

variable origin_access_identities {
    description = "Map of CloudFront origin access identities (value as a comment)"
    type        = map(string)
    default     = {}
}

variable aliases {
    description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
    type        = list(string)
    default     = null
}

variable hosted_zone {
    description = "hosted_zone name"
    type = string
}

variable comment {
    description = "Any comments you want to include about the distribution."
    type        = string
    default     = null
}

variable default_root_object {
    description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
    type        = string
    default     = null
}

variable enabled {
    description = "Whether the distribution is enabled to accept end user requests for content."
    type        = bool
    default     = true
}

variable http_version {
    description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
    type        = string
    default     = "http2"
}

variable is_ipv6_enabled {
    description = "Whether the IPv6 is enabled for the distribution."
    type        = bool
    default     = true
}

variable price_class {
    description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
    type        = string
    default     = "PriceClass_All"
}

variable retain_on_delete {
    description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
    type        = bool
    default     = false
}

variable wait_for_deployment {
    description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process."
    type        = bool
    default     = false
}

variable web_acl_id {
    description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
    type        = string
    default     = null
}

variable cdn_tags {
    description = "A map of tags to assign to the resource."
    type        = map(string)
    default     = null
}

variable origin {
    description = "One or more origins for this distribution (multiples allowed)."
    type        = any
    default     = null
}

variable origin_group {
    description = "One or more origin_group for this distribution (multiples allowed)."
    type        = any
    default     = {}
}

variable viewer_certificate {
    description = "The SSL configuration for this distribution"
    type        = any
    default = {
        cloudfront_default_certificate = true
        minimum_protocol_version       = "TLSv1"
        ssl_support_method             = "sni-only"
    }
}

variable geo_restriction {
    description = "The restriction configuration for this distribution (geo_restrictions)"
    type        = any
    default     = {}
}

variable logging_config {
    description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
    type        = any
    default     = {}
}

variable custom_error_response {
    description = "One or more custom error response elements"
    type        = any
    default     = {}
}

variable default_cache_behavior {
    description = "The default cache behavior for this distribution"
    type        = any
    default     = {
        #target_origin_id       = "s3_test"
        viewer_protocol_policy = "redirect-to-https"

        allowed_methods = ["GET", "HEAD", "OPTIONS"]
        cached_methods  = ["GET", "HEAD"]
        compress        = true
        query_string    = true
    }
}

variable ordered_cache_behavior {
    description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
    type        = any
    default     = [
        {
            path_pattern           = "/static/*"
            #target_origin_id       = "s3_test"
            viewer_protocol_policy = "redirect-to-https"

            allowed_methods = ["GET", "HEAD", "OPTIONS"]
            cached_methods  = ["GET", "HEAD"]
            compress        = true
            query_string    = true
        }
    ]
}