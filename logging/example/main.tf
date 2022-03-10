locals {
  resource_loc = "TEST-AN2-TEST"
}

module "cloudtrail_logging" {
  source            = "../"
  aws_region        = "ap-northeast-2"
  shared_account_id = "794410467178" # shared service account ID
  vpc_id            = "vpc-0af15577cbb39fdab"
  #subnet_ids             = ["subnet-07430e7c334301edb", "subnet-0a49387a270b63ef7"]
  #vpc_security_group_ids = ["sg-0ad9922c046e356b5"]

  central_logging_bucket = ""
  versioning_enabled     = true
  flow_logs_enabled      = 0

  cloudtrail_lifecycle_rule_enabled             = true
  cloudtrail_prefix                             = "CloudTrail"
  cloudtrail_noncurrent_version_expiration_days = 30
  cloudtrail_enable_glacier_transition          = false
  cloudtrail_noncurrent_version_transition_days = 5
  cloudtrail_standard_transition_days           = 30
  cloudtrail_glacier_transition_days            = 60
  cloudtrail_expiration_days                    = 90

  flowlogs_lifecycle_rule_enabled             = true
  flowlogs_prefix                             = "VPCFlowLogs"
  flowlogs_noncurrent_version_expiration_days = 30
  flowlogs_enable_glacier_transition          = false
  flowlogs_noncurrent_version_transition_days = 5
  flowlogs_standard_transition_days           = 30
  flowlogs_glacier_transition_days            = 60
  flowlogs_expiration_days                    = 90

  s3_access_log_lifecycle_enabled                  = true
  s3_access_log_prefix                             = "S3_Access_Logs"
  s3_access_log_noncurrent_version_expiration_days = 30
  s3_access_log_enable_glacier_transition          = false
  s3_access_log_noncurrent_version_transition_days = 5
  s3_access_log_standard_transition_days           = 30
  s3_access_log_glacier_transition_days            = 60
  s3_access_log_expiration_days                    = 90

  elb_access_log_lifecycle_rule_enabled             = true
  elb_access_log_prefix                             = "ELB_Access_Logs"
  elb_access_log_noncurrent_version_expiration_days = 30
  elb_access_log_enable_glacier_transition          = false
  elb_access_log_noncurrent_version_transition_days = 5
  elb_access_log_standard_transition_days           = 30
  elb_access_log_glacier_transition_days            = 60
  elb_access_log_expiration_days                    = 90

  cloudtrail_name                      = "${local.resource_loc}-CLOUDTRAIL"
  cloudwatch_log_group_cloudtrail_name = "${local.resource_loc}-CLOUDWATCH-CLOUDTRAIL"
  cloudwatch_log_group_flowlogs_name   = "${local.resource_loc}-CLOUDWATCH-FLOWLOGS"

  cloudtrail_lifecycle_rule_name     = "${local.resource_loc}-S3-LIFECYCLE-CLOUDTRAIL"
  flowlogs_lifecycle_rule_name       = "${local.resource_loc}-S3-LIFECYCLE-FLOWLOGS"
  s3_access_log_lifecycle_name       = "${local.resource_loc}-S3-LIFECYCLE-S3"
  elb_access_log_lifecycle_rule_name = "${local.resource_loc}-S3-LIFECYCLE-ELB"

  iam_role_cloudtrail_name        = "${local.resource_loc}-IAM-ROLE-CLOUDTRAIL"
  iam_role_lambda_name            = "${local.resource_loc}-IAM-ROLE-LAMBDA"
  iam_role_flowlogs_name          = "${local.resource_loc}-IAM-ROLE-FLOWLOGS"
  iam_role_policy_cloudtrail_name = "${local.resource_loc}-IAM-ROLE-POLICY-CLOUDTRAIL"
  iam_role_policy_lambda_name     = "${local.resource_loc}-IAM-ROLE-POLICY-LAMBDA"
  iam_role_policy_flowlogs_name   = "${local.resource_loc}-IAM-ROLE-POLICY-FLOWLOGS"

  # For tags
  tags = {
    Stage      = "DEV"
    Org        = "Cloud team"
    Service    = "PILOT-AP"
    Owner      = "Shinhan DS"
    Project    = "PILOT"
    No_managed = "TRUE"
    History    = "initial"
  }
}
############################################ SOURCE S3 BUCKET (local logs) ############################################
##AWS Resource in Source Account:
#-  IAM Role (for lambda to assume role during function execution)
#-	S3 Bucket (with permission to put logs in the destination account)
#-	Lambda function (copies logs)
#-	SNS Notification (event handler between S3 bucket and Lambda)

## Paremeters required
# dest_log_bucket.bucket = the name of the bucket in the destination account
# bucket_name_prefix - naming prefix of the logs e.g. bcdev-s3logsbucket
# bucket_region - region of the source log bucket
