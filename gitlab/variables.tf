variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}
variable "shared_account_id" {
  type    = string
  default = ""
}

variable "ec2_instance_ami" {
  type    = string
  default = "ami-00f1068284b9eca92"
}
variable "ec2_instance_type" {
  type    = string
  default = "t3.large"
}


variable "ec2_ebs_optimized" {
  type    = bool
  default = true
}
variable "ec2_disable_api_termination" {
  type    = bool
  default = false
}
variable "ec2_block_volume_size" {
  type    = string
  default = "20"
}
variable "ec2_block_volume_type" {
  type    = string
  default = "gp3"
}
variable "ec2_block_encrypted" {
  type    = bool
  default = true
}
variable "ec2_block_delete_on_termination" {
  type    = bool
  default = false
}

variable "gitlab_domain_name" {
  type    = string
  default = null
}
variable "gitlab_host_name" {
  type    = string
  default = null
}
variable "gitlab_url" {
  type    = string
  default = null
}
variable "gitlab_version" {
  type    = string
  default = "13.10.2-ce.0"
}
variable "gitlab_runner_version" {
  type    = string
  default = "13.10.0"
}
variable "whitelist_ips" {
  type    = list(any)
  default = null
}

################################################################################
# Names
################################################################################

variable "ec2_instance_name" {
  type    = string
  default = ""
}
variable "ec2_instance_block_name" {
  type    = string
  default = ""
}
variable "ec2_instance_eip_name" {
  type    = string
  default = ""
}


variable "iam_name" {
  type    = string
  default = ""
}
variable "iam_profile_name" {
  type    = string
  default = ""
}
variable "iam_policy_name" {
  type    = string
  default = ""
}
variable "iam_assume_policy_name" {
  type    = string
  default = ""
}
variable "security_group_internal" {
  type    = string
  default = ""
}
variable "security_group_external" {
  type    = string
  default = ""
}
variable "lb_name" {
  type    = string
  default = ""
}
variable "lb_target_group_name" {
  type    = string
  default = ""
}

################################################################################
# 기생성 id
################################################################################
variable "vpc_id" {
  type    = string
  default = null
}
variable "subnet_ids" {
  type    = list(string)
  default = null
}


################################################################################
# Common
################################################################################
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  type = map(any)
  default = {
    us-east-1      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    us-east-2      = ["us-east-2a", "eu-east-2b", "eu-east-2c"]
    us-west-1      = ["us-west-1a", "us-west-1c"]
    us-west-2      = ["us-west-2a", "us-west-2b", "us-west-2c"]
    ca-central-1   = ["ca-central-1a", "ca-central-1b"]
    eu-west-1      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    eu-west-2      = ["eu-west-2a", "eu-west-2b"]
    eu-central-1   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b"]
    sa-east-1      = ["sa-east-1a", "sa-east-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b"]
    ap-southeast-2 = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
    ap-northeast-2 = ["ap-northeast-2a", "ap-northeast-2c"]
  }
}
