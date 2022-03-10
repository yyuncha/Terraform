################################################################################
# Common properties
################################################################################
variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}
variable "shared_account_id" {
  type    = string
  default = ""
}
variable "vpc_id" {
  type        = string
  default     = null
  description = "Specifies VPC ID of flow logs"
}

################################################################################
# access_logging
################################################################################

variable "versioning_enabled" {
  type    = bool
  default = true
}
variable "s3_access_log_lifecycle_enabled" {
  type    = bool
  default = true
}
variable "s3_access_log_prefix" {
  type        = string
  default     = "S3_Access_Logs"
  description = "The S3 prefix for AWS s3_access_log."
}

variable "s3_access_log_noncurrent_version_expiration_days" {
  type    = number
  default = 30
}
variable "s3_access_log_enable_glacier_transition" {
  type    = bool
  default = false
}
variable "s3_access_log_noncurrent_version_transition_days" {
  type    = number
  default = 5
}
variable "s3_access_log_standard_transition_days" {
  type    = number
  default = 30
}
variable "s3_access_log_glacier_transition_days" {
  type    = number
  default = 60
}
variable "s3_access_log_expiration_days" {
  type    = number
  default = 90
}
variable "elb_access_log_lifecycle_rule_enabled" {
  type    = bool
  default = true
}
variable "elb_access_log_prefix" {
  type        = string
  default     = "ELB_Access_Logs"
  description = "The S3 prefix for AWS elb_access_logging."
}
variable "elb_access_log_noncurrent_version_expiration_days" {
  type    = number
  default = 30
}
variable "elb_access_log_enable_glacier_transition" {
  type    = bool
  default = false
}
variable "elb_access_log_noncurrent_version_transition_days" {
  type    = number
  default = 5
}
variable "elb_access_log_glacier_transition_days" {
  type    = number
  default = 60
}
variable "elb_access_log_standard_transition_days" {
  type    = number
  default = 30
}
variable "elb_access_log_expiration_days" {
  type    = number
  default = 90
}
################################################################################
# iam
################################################################################
variable "flow_logs_enabled" {
  type    = number
  default = 0
}

################################################################################
# cloudtrail
################################################################################

variable "bucket_name_prefix" {
  type        = string
  default     = ""
  description = "Specifies prefix of the logging bucket name in local account (usually the account ID)"
}

variable "central_logging_bucket" {
  type        = string
  default     = ""
  description = "Specifies prefix of the logging bucket name in local account (usually the account ID)"
}

variable "cloudtrail_lifecycle_rule_enabled" {
  type    = bool
  default = true
}

variable "cloudtrail_prefix" {
  type        = string
  default     = "CloudTrail"
  description = "The S3 prefix for AWS CloudTrail."
}

variable "cloudtrail_noncurrent_version_expiration_days" {
  type    = number
  default = 30
}
variable "cloudtrail_enable_glacier_transition" {
  type    = bool
  default = false
}
variable "cloudtrail_noncurrent_version_transition_days" {
  type    = number
  default = 5
}

variable "cloudtrail_standard_transition_days" {
  type    = number
  default = 30
}

variable "cloudtrail_glacier_transition_days" {
  type    = number
  default = 60
}
variable "cloudtrail_expiration_days" {
  type    = number
  default = 90
}
variable "project" {
  type        = string
  default     = "UnKnown"
  description = "Specifies the value of the Project tag"
}

variable "environment" {
  type        = string
  default     = "UnKnown"
  description = "Specifies the value of the Environment tag"
}



variable "flowlogs_lifecycle_rule_enabled" {
  type    = bool
  default = true
}
variable "flowlogs_prefix" {
  type        = string
  default     = "VPCFlowLogs"
  description = "The S3 prefix for AWS vpcflowlogs."
}
variable "flowlogs_noncurrent_version_expiration_days" {
  type    = number
  default = 30
}
variable "flowlogs_enable_glacier_transition" {
  type    = bool
  default = false
}
variable "flowlogs_noncurrent_version_transition_days" {
  type    = number
  default = 5
}
variable "flowlogs_standard_transition_days" {
  type    = number
  default = 30
}
variable "flowlogs_glacier_transition_days" {
  type    = number
  default = 60
}
variable "flowlogs_expiration_days" {
  type    = number
  default = 90
}


################################################################################
# Names
################################################################################\
variable "cloudtrail_name" {
  type    = string
  default = ""
}
variable "cloudwatch_log_group_cloudtrail_name" {
  type    = string
  default = ""
}

variable "cloudwatch_log_group_flowlogs_name" {
  type    = string
  default = ""
}


variable "cloudtrail_lifecycle_rule_name" {
  type    = string
  default = "cloudtrail_lifecyle_rule"
}
variable "flowlogs_lifecycle_rule_name" {
  type    = string
  default = "flowlogs_lifecyle_rule"
}
variable "s3_access_log_lifecycle_name" {
  type    = string
  default = "s3_access_log_lifecyle_rule"
}
variable "elb_access_log_lifecycle_rule_name" {
  type    = string
  default = "elb_access_log_lifecyle_rule"
}


variable "iam_role_cloudtrail_name" {
  type    = string
  default = ""
}
variable "iam_role_lambda_name" {
  type    = string
  default = ""
}
variable "iam_role_flowlogs_name" {
  type    = string
  default = ""
}
variable "iam_role_policy_cloudtrail_name" {
  type    = string
  default = ""
}
variable "iam_role_policy_lambda_name" {
  type    = string
  default = "IAM_ROLE_CLOUDTRAIL_CLOUDWATCH_LOGS"
}
variable "iam_role_policy_flowlogs_name" {
  type    = string
  default = ""
}

################################################################################
# Common
################################################################################
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
