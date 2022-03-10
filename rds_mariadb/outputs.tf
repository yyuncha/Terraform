output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.mariadb.*.name
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.mariadb.*.id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = aws_db_instance.mariadb.*.resource_id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.mariadb.*.address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.mariadb.*.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.mariadb.*.endpoint
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.mariadb.*.availability_zone
}

output "db_security_group_id" {
  description = "The security group ID of the RDS DB instance"
  value       = aws_security_group.mariadb.*.id
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = aws_iam_role.mariadb.*.name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = aws_iam_role.mariadb.*.arn
}