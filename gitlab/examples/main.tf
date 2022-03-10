locals {
  resource_loc  = "TEST-AN2-DEV"
  instance_name = "GITLAB"
  gitlab_domain = "shinhans.tk"
}

module "gitlab" {
  source            = "../"
  aws_region        = "ap-northeast-2"
  shared_account_id = "151564769076" # shared service account ID

  vpc_id                          = "vpc-0a3d2b2182d97ee50"
  subnet_ids                      = ["subnet-07430e7c334301edb", "subnet-0a49387a270b63ef7"]
  ec2_instance_ami                = "ami-00f1068284b9eca92"
  ec2_instance_type               = "t3.large"
  ec2_ebs_optimized               = true
  ec2_disable_api_termination     = false
  ec2_block_volume_size           = "20"
  ec2_block_volume_type           = "gp3"
  ec2_block_encrypted             = true
  ec2_block_delete_on_termination = false

  gitlab_domain_name    = local.gitlab_domain
  gitlab_host_name      = "gitlab.${local.gitlab_domain}"
  gitlab_url            = "http://gitlab.${local.gitlab_domain}"
  gitlab_version        = "13.10.2-ce.0"
  gitlab_runner_version = "13.10.0"
  whitelist_ips = [
    "59.18.215.72/32", #Shinhan local
  ]
  ec2_instance_name       = "${local.resource_loc}-EC2-${local.instance_name}"
  ec2_instance_block_name = "${local.resource_loc}-EC2-${local.instance_name}-BLOCK"
  ec2_instance_eip_name   = "${local.resource_loc}-EC2-${local.instance_name}-EIP"
  iam_name                = "${local.resource_loc}-IAM-${local.instance_name}"
  iam_profile_name        = "${local.resource_loc}-IAM-${local.instance_name}-PROFILE"
  iam_policy_name         = "${local.resource_loc}-IAM-${local.instance_name}-POLICY"
  iam_assume_policy_name  = "${local.resource_loc}-IAM-${local.instance_name}-ASSUME-POLICY"
  lb_name                 = "${local.resource_loc}-LB-${local.instance_name}"
  lb_target_group_name    = "${local.resource_loc}-LB-${local.instance_name}-TG-TCP80"
  security_group_external = "${local.resource_loc}-SG-${local.instance_name}-ALB"
  security_group_internal = "${local.resource_loc}-SG-${local.instance_name}-WEB"
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
