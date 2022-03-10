resource "aws_instance" "gitlab_ec2_instance" {
  ami                     = var.ec2_instance_ami
  instance_type           = var.ec2_instance_type
  iam_instance_profile    = aws_iam_instance_profile.iam_role_gitlab_profile.name
  vpc_security_group_ids  = [aws_security_group.gitlab_sg_internal.id]
  subnet_id               = element(var.subnet_ids, 1)
  user_data               = data.template_cloudinit_config.gitlab_cloudinit_config.rendered
  ebs_optimized           = var.ec2_ebs_optimized
  disable_api_termination = var.ec2_disable_api_termination
  root_block_device {
    volume_size           = var.ec2_block_volume_size
    volume_type           = var.ec2_block_volume_type
    encrypted             = var.ec2_block_encrypted
    delete_on_termination = var.ec2_block_delete_on_termination
    tags                  = merge({ Name = var.ec2_instance_block_name }, var.tags)
  }
  tags = merge({ Name = var.ec2_instance_name }, var.tags)
}

resource "aws_eip" "gitlab_nat_eip_public" {
  vpc      = true
  instance = aws_instance.gitlab_ec2_instance.id
  tags     = merge({ Name = var.ec2_instance_eip_name }, var.tags)
}

data "template_file" "gitlab_user_data" {
  template = file("${path.module}/gitlab_user_data.sh")

  vars = {
    GITLAB_URL            = var.gitlab_url
    GITLAB_VERSION        = var.gitlab_version
    GITLAB_RUNNER_VERSION = var.gitlab_runner_version
    AWS_ACCOUNT_ID        = var.shared_account_id
    REGION                = var.aws_region
  }
}

data "template_cloudinit_config" "gitlab_cloudinit_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.gitlab_user_data.rendered
  }
}
