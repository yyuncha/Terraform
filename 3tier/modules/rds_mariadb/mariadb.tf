################################################################################
# Random Password
################################################################################
resource "random_password" "password" {
    length           = 16
    special          = true
    override_special = "_%#"
}

resource "aws_ssm_parameter" "mariadb" {
    name        = var.db_name_user
    description = "The parameter of MariaDB"
    type        = "SecureString"
    value       = random_password.password.result

    tags = merge(var.parameter_store_tags, { Name = var.parameter_store_name })
}

################################################################################
# Enhanced Monitoring
################################################################################

resource "aws_iam_role" "mariadb" {
    name               = var.monitoring_role_name
    assume_role_policy = data.aws_iam_policy_document.mariadb.json

    tags = merge(var.monitoring_role_tags, { Name = var.monitoring_role_name })
}

resource "aws_iam_role_policy_attachment" "mariadb" {
    role       = aws_iam_role.mariadb.name
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

################################################################################
# DB Subnet
################################################################################
resource "aws_db_subnet_group" "mariadb" {
    name        = lower(var.db_subnet_group_name)
    subnet_ids  = var.db_subnet_ids

    tags = merge(var.db_subnet_group_tags, { Name = var.db_subnet_group_name })
}

################################################################################
# DB Option group
################################################################################
resource "aws_db_option_group" "mariadb" {
    name                 = lower(var.option_group_name)
    engine_name          = "mariadb"
    major_engine_version = var.option_engine_version

    dynamic "option" {
        for_each = var.db_options

        content {
            option_name                    = option.value.option_name
            port                           = lookup(option.value, "port", null)
            version                        = lookup(option.value, "version", null)
            db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
            vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

            dynamic "option_settings" {
                for_each = lookup(option.value, "option_settings", [])
                content {
                    name  = lookup(option_settings.value, "name", null)
                    value = lookup(option_settings.value, "value", null)
                }
            }
        }
    }

    tags = merge(var.option_group_tags, { Name = var.option_group_name })

    lifecycle {
        create_before_destroy = true
    }

}

################################################################################
# DB Parameter group
################################################################################
resource "aws_db_parameter_group" "mariadb" {
    name      = lower(var.parameter_group_name)
    family    = var.parameter_family

    dynamic "parameter" {
        for_each = var.db_parameters
        content {
            name         = parameter.value.name
            value        = parameter.value.value
            apply_method = lookup(parameter.value, "apply_method", null)
        }
  }

    tags = merge(var.parameter_group_tags, { Name = var.parameter_group_name })

    lifecycle {
        create_before_destroy = true
    }    
}

################################################################################
# RDS instance
################################################################################
resource "aws_db_instance" "mariadb" {
    name                        = var.database_name
    identifier                  = lower(var.identifier)
    engine                      = "mariadb"
    engine_version              = var.engine_version
    port                        = var.db_port
    instance_class              = var.instance_class
    storage_type                = var.storage_type
    iops                        = var.iops
    allocated_storage           = var.allocated_storage
    max_allocated_storage       = var.max_allocated_storage
    storage_encrypted           = var.storage_encrypted
    kms_key_id                  = var.kms_key_id
    publicly_accessible         = var.publicly_accessible
    multi_az                    = var.multi_az
    deletion_protection         = var.db_deletion_protection
    vpc_security_group_ids      = [ aws_security_group.rds_security_group.id ]
    username                    = var.username
    password                    = random_password.password.result

    apply_immediately           = var.apply_immediately
    allow_major_version_upgrade = var.allow_major_version_upgrade
    auto_minor_version_upgrade  = var.auto_minor_version_upgrade
    
    maintenance_window          = var.maintenance_window
    backup_window               = var.backup_window
    backup_retention_period     = var.backup_retention_period
    delete_automated_backups    = var.delete_automated_backups

    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
    monitoring_interval             = var.monitoring_interval
    monitoring_role_arn             = aws_iam_role.mariadb.arn
    performance_insights_enabled    = var.performance_insights_enabled
    performance_insights_kms_key_id = var.kms_key_id
    performance_insights_retention_period = var.performance_insights_retention_period

    copy_tags_to_snapshot     = var.copy_tags_to_snapshot
    skip_final_snapshot       = var.skip_final_snapshot
    final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier

    option_group_name    = aws_db_option_group.mariadb.name
    parameter_group_name = aws_db_parameter_group.mariadb.id
    db_subnet_group_name = aws_db_subnet_group.mariadb.id

    tags = merge(var.database_tags, { Name = var.identifier })

    depends_on = [
        aws_security_group.rds_security_group,
        random_password.password,
        aws_iam_role.mariadb,
        aws_db_option_group.mariadb,
        aws_db_parameter_group.mariadb,
        aws_db_subnet_group.mariadb
    ]
}