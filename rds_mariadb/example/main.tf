locals {
    aws_region      = "ap-northeast-2"
    resource_loc    = "TEST-AN2-DEV"
    database_name   = "MARIADB1"
    master_username = "dbadmin"
}

provider "aws" {
    region  = local.aws_region
}

module "mariadb" {
    source = "../../../modules/rds_mariadb"

    #### For creating Parameter store for MySQL master user's password
    parameter_store_name    = "${local.resource_loc}-RDS-PRM-${local.database_name}-MASTER"
    db_name_user            = "/${local.resource_loc}-RDS-${local.database_name}/${local.master_username}"

    #### For creating RDS DB's security group
    sg_name                 = "${local.resource_loc}-SG-RDS-${local.database_name}"
    vpc_id                  = "vpc-0af15577cbb39fdab"
    subnet_cidr_blocks      = null
    security_groups         = [ "sg-041f589c9b900416a" ]

    #### For creating RDS monitoring role
    monitoring_role_name    = "${local.resource_loc}-ROL-RDS-MON-${local.database_name}"

    #### For creating DB subnets
    db_subnet_group_name    = "${local.resource_loc}-SBN-RDS-${local.database_name}"
    subnet_ids              = ["subnet-06b79ae61a15f3b3a", "subnet-0e7719027da637abf"]

    ##### For creating Option group and Parameter group
    option_group_name       = "${local.resource_loc}-RDS-OPT-${local.database_name}"
    option_engine_version   = "10.3"

    parameter_group_name    = "${local.resource_loc}-RDS-PRM-${local.database_name}"
    parameter_family        = "mariadb10.3"

    #### For creating RDS DB
    database_name           = local.database_name
    identifier              = "${local.resource_loc}-RDS-${local.database_name}"
    engine_version          = "10.3.20"
    port                    = "3306"
    instance_class          = "db.t3.medium"
    storage_type            = "gp2"
    allocated_storage       = 20
    max_allocated_storage   = 100
    kms_key_id              = "arn:aws:kms:ap-northeast-2:794410467178:key/812d7b22-f49b-4643-92cf-2ab905d4c89a"
    multi_az                = true
    username                = local.master_username

    apply_immediately       = true
    maintenance_window      = "mon:15:00-mon:16:30"
    backup_window           = "17:00-19:00"
    backup_retention_period = 35

    delete_automated_backups    = true
    deletion_protection         = false

    tags = {
        Stage       = "DEV"
        Org         = "Cloud_service"
        Service     = "Pilot"
        Owner       = "ShinhanDS"
        Project     = "Pilot"
        No_managed  = "FALSE"
        History     = "-"    
    }

    db_options = []

    db_parameters = [
        {
            name  = "autocommit"
            value = "0"
            apply_method = "immediate"
        },
        {
            name  = "back_log"
            value = "512"
            apply_method = "pending-reboot"
        },
        {
            name  = "binlog_format"
            value = "ROW"
            apply_method = "immediate"
        },
        {
            name  = "bulk_insert_buffer_size"
            value = "67108864"
            apply_method = "immediate"
        },
        {
            name  = "character_set_server"
            value = "utf8"
            apply_method = "immediate"
        },
        {
            name  = "collation_server"
            value = "utf8_bin"
            apply_method = "immediate"
        },
        {
            name  = "event_scheduler"
            value = "ON"
            apply_method = "immediate"
        },
        {
            name  = "ft_min_word_len"
            value = "4"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_buffer_pool_size"
            value = "{DBInstanceClassMemory*1/2}"
            apply_method = "immediate"
        },
        {
            name  = "innodb_log_buffer_size"
            value = "64000000"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_log_file_size"
            value = "1048576000"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_open_files"
            value = "4096"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_print_all_deadlocks"
            value = "1"
            apply_method = "immediate"
        },
        {
            name  = "innodb_read_io_threads"
            value = "8"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_rollback_on_timeout"
            value = "0"
            apply_method = "pending-reboot"
        },
        {
            name  = "innodb_rollback_segments"
            value = "128"
            apply_method = "immediate"
        },
        {
            name  = "innodb_table_locks"
            value = "1"
            apply_method = "immediate"
        },
        {
            name  = "innodb_thread_concurrency"
            value = "0"
            apply_method = "immediate"
        },
        {
            name  = "innodb_write_io_threads"
            value = "8"
            apply_method = "pending-reboot"
        },
        {
            name  = "join_buffer_size"
            value = "1048576"
            apply_method = "immediate"
        },
        {
            name  = "key_buffer_size"
            value = "33554432"
            apply_method = "immediate"
        },
        {
            name  = "log_bin_trust_function_creators"
            value = "1"
            apply_method = "immediate"
        },
        {
            name  = "long_query_time"
            value = "1"
            apply_method = "immediate"
        },
        {
            name  = "lower_case_table_names"
            value = "1"
            apply_method = "pending-reboot"
        },
        {
            name  = "max_allowed_packet"
            value = "1048576000"
            apply_method = "immediate"
        },
        {
            name  = "max_connect_errors"
            value = "99999"
            apply_method = "pending-reboot"
        },
        {
            name  = "max_connections"
            value = "500"
            apply_method = "immediate"
        },
        {
            name  = "max_heap_table_size"
            value = "1048576000"
            apply_method = "immediate"
        },
        {
            name  = "performance_schema"
            value = "1"
            apply_method = "pending-reboot"
        },
        {
            name  = "query_cache_limit"
            value = "0"
            apply_method = "immediate"
        },
        {
            name  = "query_cache_size"
            value = "0"
            apply_method = "immediate"
        },
        {
            name  = "query_cache_type"
            value = "0"
            apply_method = "pending-reboot"
        },
        {
            name  = "read_buffer_size"
            value = "1048576"
            apply_method = "immediate"
        },
        {
            name  = "read_rnd_buffer_size"
            value = "1048576"
            apply_method = "immediate"
        },
        {
            name  = "skip_name_resolve"
            value = "1"
            apply_method = "pending-reboot"
        },
        {
            name  = "slow_query_log"
            value = "1"
            apply_method = "immediate"
        },
        {
            name  = "sort_buffer_size"
            value = "1048576"
            apply_method = "immediate"
        },
        {
            name  = "thread_cache_size"
            value = "200"
            apply_method = "immediate"
        },
        {
            name  = "thread_stack"
            value = "262144"
            apply_method = "pending-reboot"
        },
        {
            name  = "tmp_table_size"
            value = "104857600"
            apply_method = "immediate"
        },
        {
            name  = "tx_isolation"
            value = "READ-COMMITTED"
            apply_method = "immediate"
        },
        {
            name  = "wait_timeout"
            value = "28800"
            apply_method = "immediate"
        },
        {
            name  = "time_zone"
            value = "Asia/Seoul"
            apply_method = "immediate"
        },
    ]
}
