################################################################################
# Launch configuration
################################################################################
resource "aws_launch_configuration" "autoscale_lc" {
    count = var.auto_scale_lt_name == null ? 1 : 0

    name                        = var.auto_scale_lc_name
    image_id                    = var.instance_ami
    instance_type               = var.instance_type
    key_name                    = var.key_name
    iam_instance_profile        = var.iam_instance_profile_name
    
    dynamic "metadata_options" {
        for_each = length(keys(var.metadata_options)) == 0 ? [] : [var.metadata_options]
        content {
            http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
            http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
            http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
        }
    }

    security_groups             = local.security_group_ids
    associate_public_ip_address = var.associate_public_ip_address

    user_data                   = var.user_data != null ? base64encode(var.user_data) : null
    enable_monitoring           = var.enable_monitoring
    ebs_optimized               = var.ebs_optimized

    dynamic "root_block_device" {
        for_each = var.root_block_device
        content {
            volume_size           = lookup(root_block_device.value, "volume_size", null)
            volume_type           = lookup(root_block_device.value, "volume_type", null)
            delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
            encrypted             = lookup(root_block_device.value, "encrypted", null)
            iops                  = lookup(root_block_device.value, "iops", null)
        }
    }

    dynamic "ebs_block_device" {
        for_each = var.ebs_block_device
        content {
            device_name           = ebs_block_device.value.device_name
            delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
            encrypted             = lookup(ebs_block_device.value, "encrypted", null)
            iops                  = lookup(ebs_block_device.value, "iops", null)
            no_device             = lookup(ebs_block_device.value, "no_device", null)
            snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
            volume_size           = lookup(ebs_block_device.value, "volume_size", null)
            volume_type           = lookup(ebs_block_device.value, "volume_type", null)
        }
    }

    dynamic "ephemeral_block_device" {
        for_each = var.ephemeral_block_device
        content {
            device_name         = ephemeral_block_device.value.device_name
            virtual_name        = lookup(ephemeral_block_device.value, "virtual_name", null)
        }
    }

    spot_price                  = var.spot_price
    placement_tenancy           = var.spot_price == null ? var.placement_tenancy : null

    lifecycle {
        create_before_destroy = true
    }
    
}

################################################################################
# Launch template
################################################################################
resource "aws_launch_template" "autoscale_lt" {
    count = var.auto_scale_lc_name == null ? 1 : 0

    name                        = var.auto_scale_lt_name
    description                 = var.auto_scale_lt_description
    update_default_version      = var.update_default_version
    default_version             = var.default_version

    dynamic "block_device_mappings" {
        for_each = var.block_device_mappings
        content {
            device_name  = block_device_mappings.value.device_name
            no_device    = lookup(block_device_mappings.value, "no_device", null)
            virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

            dynamic "ebs" {
                for_each = flatten([lookup(block_device_mappings.value, "ebs", [])])
                content {
                    delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
                    encrypted             = lookup(ebs.value, "encrypted", null)
                    kms_key_id            = lookup(ebs.value, "kms_key_id", null)
                    iops                  = lookup(ebs.value, "iops", null)
                    throughput            = lookup(ebs.value, "throughput", null)
                    snapshot_id           = lookup(ebs.value, "snapshot_id", null)
                    volume_size           = lookup(ebs.value, "volume_size", null)
                    volume_type           = lookup(ebs.value, "volume_type", null)
                }
            }
        }
    }
    
    dynamic "capacity_reservation_specification" {
        for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
        content {
            capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

            dynamic "capacity_reservation_target" {
                for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", [])
                content {
                    capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
                }
            }
        }
    }

    dynamic "cpu_options" {
        for_each = var.cpu_options != null ? [var.cpu_options] : []
        content {
            core_count       = cpu_options.value.core_count
            threads_per_core = cpu_options.value.threads_per_core
        }
    }

    dynamic "credit_specification" {
        for_each = var.credit_specification != null ? [var.credit_specification] : []
        content {
            cpu_credits = credit_specification.value.cpu_credits
        }
    }

    disable_api_termination              = var.disable_api_termination
    ebs_optimized               = var.ebs_optimized

    dynamic "elastic_gpu_specifications" {
        for_each = var.elastic_gpu_specifications != null ? [var.elastic_gpu_specifications] : []
        content {
            type = elastic_gpu_specifications.value.type
        }
    }

    dynamic "elastic_inference_accelerator" {
        for_each = var.elastic_inference_accelerator != null ? [var.elastic_inference_accelerator] : []
        content {
            type = elastic_inference_accelerator.value.type
        }
    }

    iam_instance_profile{
        name = var.iam_instance_profile_name
        arn  = var.iam_instance_profile_arn
    }

    image_id                                = var.instance_ami
    instance_initiated_shutdown_behavior    = var.instance_initiated_shutdown_behavior

    dynamic "instance_market_options" {
        for_each = var.instance_market_options != null ? [var.instance_market_options] : []
        content {
        market_type = instance_market_options.value.market_type

        dynamic "spot_options" {
            for_each = lookup(instance_market_options.value, "spot_options", null) != null ? [instance_market_options.value.spot_options] : []
            content {
                block_duration_minutes         = spot_options.value.block_duration_minutes
                instance_interruption_behavior = lookup(spot_options.value, "instance_interruption_behavior", null)
                max_price                      = lookup(spot_options.value, "max_price", null)
                spot_instance_type             = lookup(spot_options.value, "spot_instance_type", null)
                valid_until                    = lookup(spot_options.value, "valid_until", null)
            }
        }
        }
    }

    instance_type               = var.instance_type
    kernel_id                   = var.kernel_id
    key_name                    = var.key_name

    dynamic "license_specification" {
        for_each = var.license_specifications != null ? [var.license_specifications] : []
        content {
        license_configuration_arn = license_specifications.value.license_configuration_arn
        }
    }

    dynamic "metadata_options" {
        for_each = var.metadata_options != null ? [var.metadata_options] : []
        content {
            http_endpoint               = lookup(metadata_options.value, "http_endpoint", null)
            http_tokens                 = lookup(metadata_options.value, "http_tokens", null)
            http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", null)
        }
    }

    dynamic "monitoring" {
        for_each = var.enable_monitoring != null ? [1] : []
        content {
            enabled = var.enable_monitoring
        }
    }

    dynamic "network_interfaces" {
        for_each = var.network_interfaces != null ? var.network_interfaces : []
        content {
            associate_carrier_ip_address    = lookup(network_interfaces.value, "associate_carrier_ip_address", null)
            associate_public_ip_address     = lookup(network_interfaces.value, "associate_public_ip_address", null)
            delete_on_termination           = lookup(network_interfaces.value, "delete_on_termination", null)
            device_index                    = lookup(network_interfaces.value, "device_index", null)
            interface_type                  = lookup(network_interfaces.value, "interface_type", null)
            network_interface_id            = lookup(network_interfaces.value, "network_interface_id", null)
            private_ip_address              = lookup(network_interfaces.value, "private_ip_address", null)
            ipv4_address_count              = lookup(network_interfaces.value, "ipv4_address_count", null)
            ipv4_addresses                  = lookup(network_interfaces.value, "ipv4_addresses", null)
            security_groups                 = lookup(network_interfaces.value, "security_groups", null)
            subnet_id                       = lookup(network_interfaces.value, "subnet_id", null)
        }

    }

    dynamic "placement" {
        for_each = var.placement != null ? [var.placement] : []
        content {
            affinity          = lookup(placement.value, "affinity", null)
            availability_zone = lookup(placement.value, "availability_zone", null)
            group_name        = lookup(placement.value, "group_name", null)
            host_id           = lookup(placement.value, "host_id", null)
            spread_domain     = lookup(placement.value, "spread_domain", null)
            tenancy           = lookup(placement.value, "tenancy", null)
            partition_number  = lookup(placement.value, "partition_number", null)
        }
    }

    ram_disk_id                 = var.ram_disk_id
    vpc_security_group_ids      = local.security_group_ids

    tags = merge({ Name = var.auto_scale_lt_name }, var.auto_scale_lt_tags)

    user_data              = base64encode(var.user_data)

    dynamic "enclave_options" {
        for_each = var.enclave_options != null ? [var.enclave_options] : []
        content {
            enabled = enclave_options.value.enabled
        }
    }

    dynamic "hibernation_options" {
        for_each = var.hibernation_options != null ? [var.hibernation_options] : []
        content {
            configured = hibernation_options.value.configured
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}

################################################################################
# Autoscaling group
################################################################################
resource "aws_autoscaling_group" "autoscale_asg" {
    name                 = var.auto_scale_group_name
    #availability_zones        = var.availability_zones[var.aws_region]
    vpc_zone_identifier       = var.ap_subnet_ids
    min_size                  = var.min_size
    max_size                  = var.max_size

    capacity_rebalance        = var.capacity_rebalance
    default_cooldown          = var.default_cooldown
    
    # launch_configuration / launch template 연결
    launch_configuration = local.launch_configuration
    dynamic "launch_template" {
        for_each = local.launch_template != null ? [true] : []
        content {
            name = local.launch_template
        }
    }

    dynamic "mixed_instances_policy" {
        for_each = var.use_mixed_instances_policy ? [var.mixed_instances_policy] : []
        content {
            dynamic "instances_distribution" {
                for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) != null ? [mixed_instances_policy.value.instances_distribution] : []
                content {
                    on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
                    on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
                    on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
                    spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
                    spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
                    spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
                }
            }

            launch_template {
                launch_template_specification {
                    launch_template_name = aws_launch_template.autoscale_lt[0].name
                }

                dynamic "override" {
                    for_each = lookup(mixed_instances_policy.value, "override", null) != null ? mixed_instances_policy.value.override : []
                    content {
                        instance_type     = lookup(override.value, "instance_type", null)
                        weighted_capacity = lookup(override.value, "weighted_capacity", null)

                        dynamic "launch_template_specification" {
                            for_each = lookup(override.value, "launch_template_specification", null) != null ? override.value.launch_template_specification : []
                            content {
                                launch_template_id = lookup(launch_template_specification.value, "launch_template_id", null)
                            }
                        }
                    }
                }
            }
        }
    }

    dynamic "initial_lifecycle_hook" {
        for_each = var.initial_lifecycle_hooks
        content {
            name                    = initial_lifecycle_hook.value.name
            default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
            heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
            lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
            notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
            notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
            role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
        }
    }

    health_check_grace_period = var.health_check_grace_period
    health_check_type       = var.health_check_type
    desired_capacity          = var.desired_capacity

    force_delete              = var.force_delete

    target_group_arns         = var.target_group_arns

    termination_policies      = var.termination_policies
    suspended_processes       = var.suspended_processes

    tags = [merge({ Name = var.auto_scale_group_name }, var.auto_scale_group_tags)]

    placement_group           = var.placement_group
    metrics_granularity       = var.metrics_granularity
    enabled_metrics           = var.enabled_metrics
    wait_for_capacity_timeout = var.wait_for_capacity_timeout
    min_elb_capacity          = var.min_elb_capacity
    wait_for_elb_capacity     = var.wait_for_elb_capacity
    protect_from_scale_in     = var.protect_from_scale_in
    service_linked_role_arn = var.service_linked_role_arn
    max_instance_lifetime     = var.max_instance_lifetime

    dynamic "instance_refresh" {
        for_each = var.instance_refresh != null ? [var.instance_refresh] : []
        content {
            strategy = instance_refresh.value.strategy
            triggers = lookup(instance_refresh.value, "triggers", null)

            dynamic "preferences" {
                for_each = lookup(instance_refresh.value, "preferences", null) != null ? [instance_refresh.value.preferences] : []
                content {
                    instance_warmup        = lookup(preferences.value, "instance_warmup", null)
                    min_healthy_percentage = lookup(preferences.value, "min_healthy_percentage", null)
                }
            }
        }
    }

    dynamic "warm_pool" {
        for_each = var.warm_pool != null ? [var.warm_pool] : []
        content {
            pool_state                  = lookup(warm_pool.value, "pool_state", null)
            min_size                    = lookup(warm_pool.value, "min_size", null)
            max_group_prepared_capacity = lookup(warm_pool.value, "max_group_prepared_capacity", null)
        }
    }

    timeouts {
        delete = var.delete_timeout
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = [
        aws_security_group.ap_security_group
    ]

}
