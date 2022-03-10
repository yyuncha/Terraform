output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = module.mariadb.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = module.mariadb.enhanced_monitoring_iam_role_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.mariadb.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.mariadb.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.mariadb.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.mariadb.db_instance_endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.mariadb.db_instance_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.mariadb.db_instance_resource_id
}

output "db_instance_name" {
  description = "The database name"
  value       = module.mariadb.db_instance_name
}