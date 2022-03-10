################################################################################
# Random Password
################################################################################
variable db_name_user {
    description = "DB Username of parameter store"
    type        = string
}

variable parameter_store_name {
    description = "Name of parameter store for RDS Master username"
    type        = string
}

variable parameter_store_tags {
    type = map
}

################################################################################
# Enhanced Monitoring
################################################################################
variable monitoring_role_name {
    description = "The name for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
    type        = string
}

variable monitoring_role_tags {
    type = map
}

################################################################################
# DB Subnet
################################################################################
variable db_subnet_group_name {
    description = "A DB subnet group to associate with this DB instance"
    type        = string
}

variable db_subnet_group_tags {
    type = map
}

################################################################################
# DB Option group
################################################################################
variable option_group_name {
    description = "Name of the option group"
    type        = string
}

variable option_group_tags {
    type = map
}

variable option_engine_version {
    description = "Specifies the major version of the engine that this option group should be associated(5.6, 5.7, 8.0)"
    type        = string
}

variable db_options {
    description = "A list of option to apply"
    type        = any
}

################################################################################
# DB Parameter group
################################################################################
variable parameter_group_name {
    description = "Name of the DB parameter group to create"
    type        = string
}

variable parameter_group_tags {
    type = map
}

variable parameter_family {
    description = "The family of the DB parameter group (mysql5.6, mysql5.7, mysql8.0)"
    type        = string
}

variable db_parameters {
    description = "A list of DB parameters(map) to apply"
    type        = list(map(string))
}

################################################################################
# RDS instance
################################################################################
variable rds_security_group {
    type    = any
}

variable ap_security_group {
    type    = string
}

variable database_name {
    description = "The DB name to create. If omitted, no database is created initially"
    type        = string
}

variable database_tags {
    type = map
}

variable identifier {
    description = "The name of the RDS instance, if ommitted, Terraform will assign a random, unique identifier"
    type        = string
}

variable engine_version {
    description = "The engine version to use"
    type        = string
}

variable db_port {
    description = "The port on which the DB accepts connections"
    type    = string
}

variable instance_class {
    description = "The instance type of the RDS instance"
    type        = string
}

variable storage_type {
    description = "One of 'standard'(magnetic), 'gp2', or 'io1'. The default is io1 if iops is specified, gp2 if not."
    type        = string
}

variable iops {
    description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
    type        = number
}

variable allocated_storage {
    description = "The allocated storage in gigabytes"
    type        = number
}

variable max_allocated_storage {
    description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
    type        = number
}

variable storage_encrypted {
    description = "Specifies whether the DB instance is encryped"
    type        = bool
}

variable kms_key_id {
    description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
    type        = string
}

variable publicly_accessible {
    description = "Bool to control if instance is publicly accessible"
    type        = bool
}

variable multi_az {
    description = "Specifies if the RDS instance is multi-AZ"
    type        = bool
}

variable db_deletion_protection {
    description = "The database can't be deleted when this value is set to true"
    type        = bool
}

variable username {
    description = "Username for the master DB user"
    type        = string
}

variable apply_immediately {
    description = "Specifies whether any database modifications are applied immediately or during the next maintenance window"
    type        = bool
}

variable allow_major_version_upgrade {
    description = "Indicates the major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
    type        = bool
}

variable auto_minor_version_upgrade {
    description = "Indicates that minor engine upgrades will be applied automatically during the maintenance window"
    type        = bool
}

variable maintenance_window {
    description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
    type        = string
}

variable backup_window {
    description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window"
    type        = string
}

variable backup_retention_period {
    description = "The days to retain backups for (0~35)"
    type        = number
}

variable delete_automated_backups {
    description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
    type        = bool
}

variable enabled_cloudwatch_logs_exports {
    description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine)"
    type        = list(string)
}

variable monitoring_interval {
    description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
    type        = number
}

variable performance_insights_enabled {
    description = "Specifies whether Performance Insights are enabled"
    type        = bool
}

variable performance_insights_retention_period {
    description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
    type        = number
}

variable copy_tags_to_snapshot {
    description = "Copy all instance tags to snapshot. Default is false"
    type        = bool
}

variable skip_final_snapshot {
    description = "Determine whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DB Snapshot is created"
    type        = bool
}

variable final_snapshot_identifier {
    description = "The name of your final DB snapshot when this DB instance is deleted. Must be provided if skip_final_snapshot is set to false."
    type        = string
}

################################################################################
# Common
################################################################################

variable aws_region {
    type    = string
}

variable vpc_id {
    type = string
}

variable db_subnet_ids {
    type = list
}