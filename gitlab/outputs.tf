output "iam_role_gitlab_profile" {
  description = "iam_role_gitlab_profile name"
  value       = aws_iam_instance_profile.iam_role_gitlab_profile.name
}

output "lb_security_group" {
  description = "gitlab_sg_external id"
  value       = aws_security_group.gitlab_sg_external.id
}
output "web_security_group" {
  description = "gitlab_sg_internal id"
  value       = aws_security_group.gitlab_sg_internal.id
}

output "gitlab_instance" {
  description = "gitlab_instance id"
  value       = aws_instance.gitlab_ec2_instance.id
}
