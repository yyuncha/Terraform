module "web_load_balancer" {
    source = "./modules/load_balancer"

    aws_region          = var.aws_region
    #availability_zones  = var.availability_zones
    ap_subnet_ids       = var.web_subnet_ids
    vpc_id              = var.vpc_id
    
    # Load Balancer
    load_balancer       = var.web_load_balancer
    load_balancer_tags  = var.web_load_balancer_tags

    lb_internal         = var.web_lb_internal
    load_balancer_type  = var.web_load_balancer_type
    lb_security_group   = var.web_lb_security_group

    prev_step           = var.web_prev_step

    lb_drop_invalid_header_fields   = var.web_lb_drop_invalid_header_fields

    lb_access_logs      = var.web_lb_access_logs
    subnet_mapping      = var.web_subnet_mapping
    lb_deletion_protection  = var.web_lb_deletion_protection
    lb_idle_timeout         = var.web_lb_idle_timeout
    lb_cross_zone_load_balancing    = var.web_lb_cross_zone_load_balancing

    lb_http2    = var.web_lb_http2
    lb_ip_address_type  = var.web_lb_ip_address_type

    load_balancer_create_timeout    = var.web_load_balancer_create_timeout
    load_balancer_update_timeout    = var.web_load_balancer_update_timeout
    load_balancer_delete_timeout    = var.web_load_balancer_delete_timeout

    # Load Balancer Listener
    lb_listener     = var.web_lb_listener

    # Target Group
    target_group    = var.web_target_group
    target_group_tags    = var.web_target_group_tags
    target_type = var.web_target_type
    deregistration_delay    = var.web_deregistration_delay
    slow_start          = var.web_slow_start
    load_balancing_algorithm_type   = var.web_load_balancing_algorithm_type
    target_port = var.web_target_port
    target_protocol = var.web_target_protocol
    proxy_protocol_v2   = var.web_proxy_protocol_v2

    healthy_threshold   = var.web_healthy_threshold
    unhealthy_threshold = var.web_unhealthy_threshold
    health_interval     = var.web_health_interval
    health_port         = var.web_health_port
    health_timeout      = var.web_health_timeout
    health_matcher      = var.web_health_matcher
    health_path         = var.web_health_path

    stickiness_enabled  = var.web_stickiness_enabled
    cookie_duration     = var.web_cookie_duration
}

module "web_auto_scaling" {
    source = "./modules/auto_scale"

    aws_region          = var.aws_region
    ap_subnet_ids       = var.web_subnet_ids
    vpc_id              = var.vpc_id

    # Autoscaling group
    auto_scale_group_name   = var.web_auto_scale_group_name
    auto_scale_group_tags   = var.web_auto_scale_group_tags

    min_size    = var.web_min_size
    max_size    = var.web_max_size

    desired_capacity    = var.web_desired_capacity
    capacity_rebalance  = var.web_capacity_rebalance
    min_elb_capacity    = var.web_min_elb_capacity

    wait_for_elb_capacity       = var.web_wait_for_elb_capacity
    wait_for_capacity_timeout   = var.web_wait_for_capacity_timeout

    default_cooldown        = var.web_default_cooldown
    protect_from_scale_in   = var.web_protect_from_scale_in

    target_group_arns   = [module.web_load_balancer.target_group]

    placement_group             = var.web_placement_group
    health_check_type           = var.web_health_check_type
    health_check_grace_period   = var.web_health_check_grace_period

    force_delete            = var.web_force_delete
    termination_policies    = var.web_termination_policies
    suspended_processes     = var.web_suspended_processes
    max_instance_lifetime   = var.web_max_instance_lifetime
    enabled_metrics         = var.web_enabled_metrics
    metrics_granularity     = var.web_metrics_granularity

    service_linked_role_arn = var.web_service_linked_role_arn
    initial_lifecycle_hooks = var.web_initial_lifecycle_hooks
    instance_refresh        = var.web_instance_refresh

    use_mixed_instances_policy  = var.web_use_mixed_instances_policy
    mixed_instances_policy      = var.web_mixed_instances_policy

    delete_timeout      = var.web_delete_timeout
    warm_pool           = var.web_warm_pool

    # Common - launch configuration or launch template
    ebs_optimized   = var.web_ebs_optimized

    iam_instance_profile_name   = var.web_iam_instance_profile_name
    iam_instance_profile_arn    = var.web_iam_instance_profile_arn
    
    key_name    = var.web_key_name
    user_data   = var.web_user_data

    enable_monitoring   = var.web_enable_monitoring
    metadata_options    = var.web_metadata_options
    instance_ami        = var.web_instance_ami
    instance_type       = var.web_instance_type

    ap_security_group       = var.web_security_group
    security_group_ids      = var.web_security_group_ids

    load_balancer_type      = var.web_load_balancer_type
    lb_security_group       = module.web_load_balancer.lb_security_group
    lb_target_port          = var.web_target_port
    lb_target_protocol      = var.web_target_protocol

    # Launch configuration
    auto_scale_lc_name      = var.web_auto_scale_lc_name

    associate_public_ip_address = var.web_associate_public_ip_address
    
    root_block_device   = var.web_root_block_device
    ebs_block_device    = var.web_ebs_block_device
    spot_price          = var.web_spot_price

    placement_tenancy       = var.web_placement_tenancy
    ephemeral_block_device  = var.web_ephemeral_block_device

    # Launch template
    auto_scale_lt_name          = var.web_auto_scale_lt_name
    auto_scale_lt_description   = var.web_auto_scale_lt_description

    default_version         = var.web_default_version
    update_default_version  = var.web_update_default_version

    disable_api_termination                 = var.web_disable_api_termination
    instance_initiated_shutdown_behavior    = var.web_instance_initiated_shutdown_behavior

    kernel_id   = var.web_kernel_id
    ram_disk_id = var.web_ram_disk_id
    cpu_options = var.web_cpu_options

    block_device_mappings               = var.web_block_device_mappings
    capacity_reservation_specification  = var.web_capacity_reservation_specification

    credit_specification            = var.web_credit_specification
    elastic_gpu_specifications      = var.web_elastic_gpu_specifications
    elastic_inference_accelerator   = var.web_elastic_inference_accelerator

    enclave_options     = var.web_enclave_options
    hibernation_options = var.web_hibernation_options
    
    instance_market_options = var.web_instance_market_options
    license_specifications  = var.web_license_specifications

    network_interfaces  = var.web_network_interfaces

    placement           = var.web_placement
    auto_scale_lt_tags  = var.web_auto_scale_lt_tags

    depends_on = [
        module.web_load_balancer
    ]
}

module "was_load_balancer" {
    source = "./modules/load_balancer"

    aws_region          = var.aws_region
    #availability_zones  = var.availability_zones
    ap_subnet_ids       = var.was_subnet_ids
    vpc_id              = var.vpc_id
    
    # Load Balancer
    load_balancer       = var.was_load_balancer
    load_balancer_tags  = var.was_load_balancer_tags

    lb_internal         = var.was_lb_internal
    load_balancer_type  = var.was_load_balancer_type
    lb_security_group   = var.was_lb_security_group

    prev_step           = var.was_prev_step
    prev_security_group = module.web_auto_scaling.ap_security_group
    prev_port           = var.was_target_port
    prev_protocol       = var.was_target_protocol

    lb_drop_invalid_header_fields   = var.was_lb_drop_invalid_header_fields

    lb_access_logs      = var.was_lb_access_logs
    subnet_mapping      = var.was_subnet_mapping
    lb_deletion_protection  = var.was_lb_deletion_protection
    lb_idle_timeout         = var.was_lb_idle_timeout
    lb_cross_zone_load_balancing    = var.was_lb_cross_zone_load_balancing

    lb_http2    = var.was_lb_http2
    lb_ip_address_type  = var.was_lb_ip_address_type

    load_balancer_create_timeout    = var.was_load_balancer_create_timeout
    load_balancer_update_timeout    = var.was_load_balancer_update_timeout
    load_balancer_delete_timeout    = var.was_load_balancer_delete_timeout

    # Load Balancer Listener
    lb_listener     = var.was_lb_listener

    # Target Group
    target_group    = var.was_target_group
    target_group_tags    = var.was_target_group_tags
    target_type = var.was_target_type
    deregistration_delay    = var.was_deregistration_delay
    slow_start          = var.was_slow_start
    load_balancing_algorithm_type   = var.was_load_balancing_algorithm_type
    target_port = var.was_target_port
    target_protocol = var.was_target_protocol
    proxy_protocol_v2   = var.was_proxy_protocol_v2

    healthy_threshold   = var.was_healthy_threshold
    unhealthy_threshold = var.was_unhealthy_threshold
    health_interval     = var.was_health_interval
    health_port         = var.was_health_port
    health_timeout      = var.was_health_timeout
    health_matcher      = var.was_health_matcher
    health_path         = var.was_health_path

    stickiness_enabled  = var.was_stickiness_enabled
    cookie_duration     = var.was_cookie_duration

    depends_on = [
        module.web_auto_scaling
    ]
}

module "was_auto_scaling" {
    source = "./modules/auto_scale"

    aws_region          = var.aws_region
    ap_subnet_ids       = var.was_subnet_ids
    vpc_id              = var.vpc_id

    # Autoscaling group
    auto_scale_group_name   = var.was_auto_scale_group_name
    auto_scale_group_tags   = var.was_auto_scale_group_tags

    min_size    = var.was_min_size
    max_size    = var.was_max_size

    desired_capacity    = var.was_desired_capacity
    capacity_rebalance  = var.was_capacity_rebalance
    min_elb_capacity    = var.was_min_elb_capacity

    wait_for_elb_capacity       = var.was_wait_for_elb_capacity
    wait_for_capacity_timeout   = var.was_wait_for_capacity_timeout

    default_cooldown        = var.was_default_cooldown
    protect_from_scale_in   = var.was_protect_from_scale_in

    target_group_arns   = [module.was_load_balancer.target_group]

    placement_group             = var.was_placement_group
    health_check_type           = var.was_health_check_type
    health_check_grace_period   = var.was_health_check_grace_period

    force_delete            = var.was_force_delete
    termination_policies    = var.was_termination_policies
    suspended_processes     = var.was_suspended_processes
    max_instance_lifetime   = var.was_max_instance_lifetime
    enabled_metrics         = var.was_enabled_metrics
    metrics_granularity     = var.was_metrics_granularity

    service_linked_role_arn = var.was_service_linked_role_arn
    initial_lifecycle_hooks = var.was_initial_lifecycle_hooks
    instance_refresh        = var.was_instance_refresh

    use_mixed_instances_policy  = var.was_use_mixed_instances_policy
    mixed_instances_policy      = var.was_mixed_instances_policy

    delete_timeout      = var.was_delete_timeout
    warm_pool           = var.was_warm_pool

    # Common - launch configuration or launch template
    ebs_optimized   = var.was_ebs_optimized

    iam_instance_profile_name   = var.was_iam_instance_profile_name
    iam_instance_profile_arn    = var.was_iam_instance_profile_arn
    
    key_name    = var.was_key_name
    user_data   = var.was_user_data

    enable_monitoring   = var.was_enable_monitoring
    metadata_options    = var.was_metadata_options
    instance_ami        = var.was_instance_ami
    instance_type       = var.was_instance_type

    ap_security_group       = var.was_security_group
    security_group_ids      = var.was_security_group_ids

    load_balancer_type      = var.was_load_balancer_type
    lb_security_group       = module.was_load_balancer.lb_security_group
    lb_target_port          = var.was_target_port
    lb_target_protocol      = var.was_target_protocol

    # Launch configuration
    auto_scale_lc_name      = var.was_auto_scale_lc_name

    associate_public_ip_address = var.was_associate_public_ip_address
    
    root_block_device   = var.was_root_block_device
    ebs_block_device    = var.was_ebs_block_device
    spot_price          = var.was_spot_price

    placement_tenancy       = var.was_placement_tenancy
    ephemeral_block_device  = var.was_ephemeral_block_device

    # Launch template
    auto_scale_lt_name          = var.was_auto_scale_lt_name
    auto_scale_lt_description   = var.was_auto_scale_lt_description

    default_version         = var.was_default_version
    update_default_version  = var.was_update_default_version

    disable_api_termination                 = var.was_disable_api_termination
    instance_initiated_shutdown_behavior    = var.was_instance_initiated_shutdown_behavior

    kernel_id   = var.was_kernel_id
    ram_disk_id = var.was_ram_disk_id
    cpu_options = var.was_cpu_options

    block_device_mappings               = var.was_block_device_mappings
    capacity_reservation_specification  = var.was_capacity_reservation_specification

    credit_specification            = var.was_credit_specification
    elastic_gpu_specifications      = var.was_elastic_gpu_specifications
    elastic_inference_accelerator   = var.was_elastic_inference_accelerator

    enclave_options     = var.was_enclave_options
    hibernation_options = var.was_hibernation_options
    
    instance_market_options = var.was_instance_market_options
    license_specifications  = var.was_license_specifications

    network_interfaces  = var.was_network_interfaces

    placement           = var.was_placement
    auto_scale_lt_tags  = var.was_auto_scale_lt_tags

    depends_on = [
        module.was_load_balancer
    ]
}

module "rds_mariadb" {
    source = "./modules/rds_mariadb"

    aws_region          = var.aws_region
    db_subnet_ids       = var.db_subnet_ids
    vpc_id              = var.vpc_id

    # DB Random Password
    db_name_user    = var.db_name_user
    parameter_store_name    = var.parameter_store_name
    parameter_store_tags    = var.parameter_store_tags

    # Enhanced Monitoring
    monitoring_role_name    = var.monitoring_role_name
    monitoring_role_tags    = var.monitoring_role_tags

    # DB Subnet
    db_subnet_group_name    = var.db_subnet_group_name
    db_subnet_group_tags    = var.db_subnet_group_tags

    # DB Option group
    option_group_name   = var.option_group_name
    option_group_tags   = var.option_group_tags
    option_engine_version   = var.option_engine_version
    db_options              = var.db_options

    # DB Parameter group
    parameter_group_name    = var.parameter_group_name
    parameter_group_tags    = var.parameter_group_tags
    parameter_family        = var.parameter_family
    db_parameters           = var.db_parameters

    # RDS instance
    rds_security_group      = var.rds_security_group
    ap_security_group       = module.was_auto_scaling.ap_security_group

    database_name       = var.database_name
    database_tags       = var.database_tags
    identifier          = var.identifier
    engine_version      = var.engine_version
    db_port             = var.db_port
    instance_class      = var.instance_class
    storage_type        = var.storage_type
    iops                = var.iops
    allocated_storage   = var.allocated_storage
    max_allocated_storage   = var.max_allocated_storage
    storage_encrypted   = var.storage_encrypted
    kms_key_id          = var.kms_key_id
    publicly_accessible = var.publicly_accessible
    multi_az            = var.multi_az
    db_deletion_protection  = var.db_deletion_protection
    username            = var.username
    apply_immediately   = var.apply_immediately
    allow_major_version_upgrade = var.allow_major_version_upgrade
    auto_minor_version_upgrade  = var.auto_minor_version_upgrade
    maintenance_window          = var.maintenance_window
    backup_window               = var.backup_window
    backup_retention_period     = var.backup_retention_period
    delete_automated_backups    = var.delete_automated_backups
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
    monitoring_interval         = var.monitoring_interval
    performance_insights_enabled    = var.performance_insights_enabled
    performance_insights_retention_period   = var.performance_insights_retention_period
    copy_tags_to_snapshot       = var.copy_tags_to_snapshot
    skip_final_snapshot         = var.skip_final_snapshot
    final_snapshot_identifier   = var.final_snapshot_identifier

    depends_on = [
        module.was_auto_scaling
    ]
}