################################################################################
# Random Password
################################################################################
variable "db_name_user" {
    description = "DB Username of parameter store"
    type        = string
    default     = ""
}

variable "parameter_store_name" {
    description = "Name of parameter store for RDS Master username"
    type        = string
    default     = "" 
}

################################################################################
# Security Group
################################################################################
variable "sg_name" {
    description = "Name of security group for Aurora DB"
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "VPC ID"
    type        = string
    default     = ""
}

variable "subnet_cidr_blocks" {
    description = "List of CIDR blocks for application subnets"
    type        = list(string)
    default     = null
}

variable "security_groups" {
    description = "List of security group names for application security group names"
    type        = list(string)
    default     = null
}

################################################################################
# Enhanced Monitoring
################################################################################
variable "monitoring_role_name" {
    description = "The name for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
    type        = string
    default     = null
}

################################################################################
# DB Subnet
################################################################################
variable "db_subnet_group_name" {
    description = "A DB subnet group to associate with this DB instance"
    type        = string
    default      = null
}

variable "subnet_ids" {
    description = "A list of VPC subnet IDs to associate with this DB instance"
    type        = list(string)
    default     = []
}

################################################################################
# DB Option group
################################################################################
variable "option_group_name" {
    description = "Name of the option group"
    type        = string
    default     = null
}

variable "option_engine_version" {
    description = "Specifies the major version of the engine that this option group should be associated(5.6, 5.7, 8.0)"
    type        = string
    default     = null
}

variable "db_options" {
    description = "A list of option to apply"
    type        = any
    default     = []
}

################################################################################
# DB Parameter group
################################################################################
variable "parameter_group_name" {
    description = "Name of the DB parameter group to create"
    type        = string
    default     = null
}

variable "parameter_family" {
    description = "The family of the DB parameter group (mysql5.6, mysql5.7, mysql8.0)"
    type        = string
    default     = null
}

variable "db_parameters" {
    description = "A list of DB parameters(map) to apply"
    type        = list(map(string))
    default     = []
}

################################################################################
# RDS instance
################################################################################
variable "database_name" {
    description = "The DB name to create. If omitted, no database is created initially"
    type        = string
    default     = null
}

variable "identifier" {
    description = "The name of the RDS instance, if ommitted, Terraform will assign a random, unique identifier"
    type        = string
    default     = ""
}

variable "engine_version" {
    description = "The engine version to use"
    type        = string
    default     = "10.3.20"
}

variable "port" {
    description = "The port on which the DB accepts connections"
    type    = string
    default = "3306"
}

variable "instance_class" {
    description = "The instance type of the RDS instance"
    type        = string
    default     = "db.t3.medium"
}

variable "storage_type" {
    description = "One of 'standard'(magnetic), 'gp2', or 'io1'. The default is io1 if iops is specified, gp2 if not."
    type        = string
    default     = "gp2"
}

variable "iops" {
    description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
    type        = number
    default     = 0
}

variable "allocated_storage" {
    description = "The allocated storage in gigabytes"
    type        = number
    default     = 100
}

variable "max_allocated_storage" {
    description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
    type        = number
    default     = null
}

variable "storage_encrypted" {
    description = "Specifies whether the DB instance is encryped"
    type        = bool
    default     = true
}

variable "kms_key_id" {
    description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
    type        = string
    default     = ""
}

variable "publicly_accessible" {
    description = "Bool to control if instance is publicly accessible"
    type        = bool
    default     = false
}

variable "multi_az" {
    description = "Specifies if the RDS instance is multi-AZ"
    type        = bool
    default     = true
}

variable "deletion_protection" {
    description = "The database can't be deleted when this value is set to true"
    type        = bool
    default     = false
}

variable "username" {
    description = "Username for the master DB user"
    type        = string
    default     = ""
}

variable "apply_immediately" {
    description = "Specifies whether any database modifications are applied immediately or during the next maintenance window"
    type        = bool
    default     = false
}

variable "allow_major_version_upgrade" {
    description = "Indicates the major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
    type        = bool
    default     = false
}

variable "auto_minor_version_upgrade" {
    description = "Indicates that minor engine upgrades will be applied automatically during the maintenance window"
    type        = bool
    default     = false
}

variable "maintenance_window" {
    description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
    type        = string
    default     = "sat:15:00-sat:16:30"
}

variable "backup_window" {
    description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window"
    type        = string
    default     = "17:00-19:00"
}

variable "backup_retention_period" {
    description = "The days to retain backups for (0~35)"
    type        = number
    default     = 35
}

variable "delete_automated_backups" {
    description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
    type        = bool
    default     = false
}

variable "enabled_cloudwatch_logs_exports" {
    description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine)"
    type        = list(string)
    default     = ["audit", "error", "general", "slowquery"]
}

variable "monitoring_interval" {
    description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
    type        = number
    default     = 60
}

variable "performance_insights_enabled" {
    description = "Specifies whether Performance Insights are enabled"
    type        = bool
    default     = true
}

variable "performance_insights_retention_period" {
    description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
    type        = number
    default     = 7
}

variable "copy_tags_to_snapshot" {
    description = "Copy all instance tags to snapshot. Default is false"
    type        = bool
    default     = false
}

variable "skip_final_snapshot" {
    description = "Determine whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DB Snapshot is created"
    type        = bool
    default     = true
}

variable "final_snapshot_identifier" {
    description = "The name of your final DB snapshot when this DB instance is deleted. Must be provided if skip_final_snapshot is set to false."
    type        = string
    default     = null
}

variable "tags" {
    description = "Name tags of security group"
    type    = map(string)
}