module "s3_bucket" {
  source        = "./modules/s3_bucket"
  bucket        = var.bucket
  acl           = var.acl
  versioning    = var.versioning
  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
  tags          = var.s3_tags
  force_destroy = var.force_destroy

  website_index_document  = var.website_index_document
  upload_object_path      = var.upload_object_path
  content_type            = var.content_type
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  object_acl = var.object_acl
}

module "cdn" {
  source = "./modules/cloudfront"

  create_distribution           = var.create_distribution
  create_origin_access_identity = var.create_origin_access_identity
  origin_access_identities      = var.origin_access_identities

  aliases     = var.aliases
  hosted_zone = var.hosted_zone
  comment     = var.comment
  enabled     = var.enabled

  http_version        = var.http_version
  default_root_object = var.default_root_object
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment

  web_acl_id   = var.web_acl_id
  cdn_tags     = var.cdn_tags
  origin       = var.origin
  origin_group = var.origin_group

  viewer_certificate = var.viewer_certificate
  geo_restriction    = var.geo_restriction
  logging_config     = var.logging_config

  custom_error_response  = var.custom_error_response
  default_cache_behavior = var.default_cache_behavior
  ordered_cache_behavior = var.ordered_cache_behavior

  s3_arn = module.s3_bucket.s3.arn
  s3_id  = module.s3_bucket.s3.id

  depends_on = [
    module.s3_bucket
  ]
}
