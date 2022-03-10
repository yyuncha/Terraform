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
}

variable target_prefix { 
    description = "To specify a key prefix for log objects."
    type = string
}

variable tags {
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