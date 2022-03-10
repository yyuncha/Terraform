################################################################################
# WEB Load Balancer
################################################################################
variable web_load_balancer {
    type    = string
}

variable web_load_balancer_tags {
    type = map
    default = {}
}

variable web_lb_internal {
    description = "Boolean determining if the load balancer is internal or externally facing."
    type        = bool
    default     = true
}

variable web_load_balancer_type {
    type    = string
    default = null
}

variable web_lb_security_group {
    type    = any
    default = null
}

variable web_prev_step {
    type    = bool
    default = false
}

variable web_lb_drop_invalid_header_fields {
    description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false)."
    type    = bool
    default = false
}

variable web_lb_access_logs {
    description = "An Access Logs block. Access Logs documented below."
    type    = any
    default = null
}

variable web_subnet_mapping {
    description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
    type        = list
    default     = []
}

variable web_lb_deletion_protection {
    type    = bool
    default = false
}

variable web_lb_idle_timeout {
    description = "The time in seconds that the connection is allowed to be idle."
    type        = number
    default     = 60
}

variable web_lb_cross_zone_load_balancing {
    description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
    type        = bool
    default     = false
}

variable web_lb_http2 {
    description = "Indicates whether HTTP/2 is enabled in application load balancers."
    type        = bool
    default     = true
}

variable web_lb_ip_address_type {
    type    = string
    default = "ipv4"
}

variable web_load_balancer_create_timeout {
    description = "Timeout value when creating the ALB."
    type        = string
    default     = "15m"
}

variable web_load_balancer_update_timeout {
    description = "Timeout value when updating the ALB."
    type        = string
    default     = "15m"
}

variable web_load_balancer_delete_timeout {
    description = "Timeout value when deleting the ALB."
    type        = string
    default     = "15m"
}

################################################################################
#  WEB Load Balancer Listener
################################################################################

variable web_lb_listener {
    description = "Load Balancer Listener resource."
    type        = any
}

################################################################################
#  WEB Target Group
################################################################################

variable web_target_group {
    description = "Name of the target group."
    type        = string
}

variable web_target_group_tags {
    type        = map
    default     = {}
}

variable web_target_type {
    description = "Type of target that you must specify when registering targets with this target group."
    type        = string
    default     = "instance"
}

variable web_deregistration_delay {
    description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
    type        = number
    default     = 300
}

variable web_slow_start {
    description = "Amount time for targets to warm up before the load balancer sends them a full share of requests."
    type        = number
    default     = 0
}

variable web_load_balancing_algorithm_type {
    description = "Determines how the load balancer selects targets when routing requests."
    type        = string
    default     = "round_robin"
}

variable web_target_port {
    description = "Port on which targets receive traffic, unless overridden when registering a specific target."
    type        = number
}

variable web_target_protocol {
    description = "Protocol to use for routing traffic to the targets."
    type        = string
}

variable web_proxy_protocol_v2 {
    description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
    type        = bool
    default     = false
}

variable web_healthy_threshold {
    description = "Number of consecutive health checks successes required before considering an unhealthy target healthy."
    type        = number
    default     = 3
}

variable web_unhealthy_threshold {
    description = "Number of consecutive health check failures required before considering the target unhealthy."
    type        = number
    default     = 3
}

variable web_health_interval {
    description = "Approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
    type        = number
    default     = 30
}

variable web_health_port {
    description = "Port to use to connect with the target."
    type        = string
    default     = "traffic-port"
}

variable web_health_timeout {
    description = "Amount of time, in seconds, during which no response means a failed health check."
    type        = number
    default     = 5
}

variable web_health_matcher {
    description = "Response codes to use when checking for a healthy responses from a target."
    type        = string
    default     = "200"
}

variable web_health_path {
    description = "Destination for the health check request."
    type        = string
    default     = "/"
}

variable web_stickiness_enabled {
    description = "Whether to enable stickiness"
    type        = bool
    default     = false
}

variable web_cookie_duration {
    description = "The time period, in seconds, during which requests from a client should be routed to the same target."
    type        = number
    default     = 86400
}

################################################################################
# WEB Autoscaling group
################################################################################
variable web_auto_scale_group_name {
    description = "Name used across the resources created"
    type        = string
}

variable web_auto_scale_group_tags {
    type        = map
    default     = {}
}

variable web_min_size {
    description = "The minimum size of the autoscaling group"
    type        = number
    default     = null
}
variable web_max_size {
    description = "The maximum size of the autoscaling group"
    type        = number
    default     = null
}

variable web_desired_capacity {
    description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
    type        = number
    default     = null
}

variable web_capacity_rebalance {
    description = "Indicates whether capacity rebalance is enabled"
    type        = bool
    default     = true
}

variable web_min_elb_capacity {
    description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
    type        = number
    default     = null
}

variable web_wait_for_elb_capacity {
    description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
    type        = number
    default     = null
}

variable web_wait_for_capacity_timeout {
    description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
    type        = string
    default     = 0
}

variable web_default_cooldown {
    description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
    type        = number
    default     = null
}

variable web_protect_from_scale_in {
    description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
    type        = bool
    default     = false
}

variable web_target_group_arns {
    description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
    type        = list(string)
    default     = []
}

variable web_placement_group {
    description = "The name of the placement group into which you'll launch your instances, if any"
    type        = string
    default     = null
}

variable web_health_check_type {
    description = "`EC2` or `ELB`. Controls how health checking is done"
    type        = string
    default     = "ELB"
}

variable web_health_check_grace_period {
    description = "Time (in seconds) after instance comes into service before checking health"
    type        = number
    default     = null
}

variable web_force_delete {
    description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
    type        = bool
    default     = null
}

variable web_termination_policies {
    description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
    type        = list(string)
    default     = null
}

variable web_suspended_processes {
    description = "A list of processes to suspend for the Auto Scaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your Auto Scaling Group from functioning properly"
    type        = list(string)
    default     = null
}

variable web_max_instance_lifetime {
    description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds"
    type        = number
    default     = null
}

variable web_enabled_metrics {
    description = "A list of metrics to collect. The allowed values are `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"
    type        = list(string)
    default     = null
}

variable web_metrics_granularity {
    description = "The granularity to associate with the metrics to collect. The only valid value is `1Minute`"
    type        = string
    default     = null
}

variable web_service_linked_role_arn {
    description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
    type        = string
    default     = null
}

variable web_initial_lifecycle_hooks {
    description = "One or more Lifecycle Hooks to attach to the Auto Scaling Group before instances are launched. The syntax is exactly the same as the separate `aws_autoscaling_lifecycle_hook` resource, without the `autoscaling_group_name` attribute. Please note that this will only work when creating a new Auto Scaling Group. For all other use-cases, please use `aws_autoscaling_lifecycle_hook` resource"
    type        = list(map(string))
    default     = []
}

variable web_instance_refresh {
    description = "If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated"
    type        = any
    default     = null
}

variable web_use_mixed_instances_policy {
    description = "Determines whether to use a mixed instances policy in the autoscaling group or not"
    type        = bool
    default     = false
}

variable web_mixed_instances_policy {
    description = "Configuration block containing settings to define launch targets for Auto Scaling groups"
    type        = any
    default     = null
}

variable web_delete_timeout {
    description = "Delete timeout to wait for destroying autoscaling group"
    type        = string
    default     = null
}

variable web_warm_pool {
    description = "If this block is configured, add a Warm Pool to the specified Auto Scaling group."
    type        = any
    default     = null
}

################################################################################
# WEB Common - launch configuration or launch template
################################################################################

variable web_ebs_optimized {
    description = "If true, the launched EC2 instance will be EBS-optimized"
    type        = bool
    default     = true
}

variable web_iam_instance_profile_name {
    description = "The name attribute of the IAM instance profile to associate with launched instances"
    type        = string
    default     = null
}

variable web_iam_instance_profile_arn {
    description = "The IAM Instance Profile ARN to launch the instance with launched instances"
    type        = string
    default     = null
}

variable web_key_name {
    description = "The key name that should be used for the instance"
    type        = string
    default     = null
}

variable web_user_data {
    description = "The Base64-encoded user data to provide when launching the instance"
    type        = string
    default     = null
}

variable web_enable_monitoring {
    description = "Enables/disables detailed monitoring"
    type        = bool
    default     = true
}

variable web_metadata_options {
    description = "Customize the metadata options for the instance"
    type        = map(string)
    default     = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 32
    }
}

variable web_instance_ami {
    type    = string
    default = "ami-00f1068284b9eca92"
}

variable web_instance_type {
    description = "The type of the instance to launch"
    type        = string
    default     = "t3.large"
}

variable web_security_group_ids {
    description = "A list of security group IDs to associate with"
    type        = list(string)
    default     = null
}

variable web_security_group {
    type        = any
    default     = null
}

################################################################################
# WEB Launch configuration
################################################################################

variable web_auto_scale_lc_name {
    description = "Name used across the resources created"
    type        = string
    default     = null
}

variable web_associate_public_ip_address {
    description = "(LC) Associate a public ip address with an instance in a VPC"
    type        = bool
    default     = false
}

variable web_root_block_device {
    description = "(LC) Customize details about the root block device of the instance"
    type        = list(map(string))
    default     = []
}

variable web_ebs_block_device {
    description = "(LC) Additional EBS block devices to attach to the instance"
    type        = list(map(string))
    default     = []
}

variable web_spot_price {
    description = "(LC) The maximum price to use for reserving spot instances (defaults to on-demand price)"
    type        = string
    default     = "0.014"
}

variable web_placement_tenancy {
    description = "(LC) The tenancy of the instance. Valid values are `default` or `dedicated`"
    type        = string
    default     = null
}

variable web_ephemeral_block_device {
    description = "(LC) Customize Ephemeral (also known as 'Instance Store') volumes on the instance"
    type        = list(map(string))
    default     = []
}

################################################################################
# WEB Launch template
################################################################################
variable web_auto_scale_lt_name {
    description = "(LT) Name used across the resources created"
    type        = string
    default     = null
}

variable web_auto_scale_lt_description {
    type        = string
    default     = null
}

variable web_default_version {
    description = "(LT) Default Version of the launch template"
    type        = string
    default     = null
}

variable web_update_default_version {
    description = "(LT) Whether to update Default Version each update. Conflicts with `default_version`"
    type        = string
    default     = null
}

variable web_disable_api_termination {
    description = "(LT) If true, enables EC2 instance termination protection"
    type        = bool
    default     = null
}

variable web_instance_initiated_shutdown_behavior {
    description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
    type        = string
    default     = null
}

variable web_kernel_id {
    description = "(LT) The kernel ID"
    type        = string
    default     = null
}

variable web_ram_disk_id {
    description = "(LT) The ID of the ram disk"
    type        = string
    default     = null
}

variable web_block_device_mappings {
    description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
    type        = list(any)
    default     = []
}

variable web_capacity_reservation_specification {
    description = "(LT) Targeting for EC2 capacity reservations"
    type        = any
    default     = null
}

variable web_cpu_options {
    description = "(LT) The CPU options for the instance"
    type        = map(string)
    default     = null
}

variable web_credit_specification {
    description = "(LT) Customize the credit specification of the instance"
    type        = map(string)
    default     = null
}

variable web_elastic_gpu_specifications {
    description = "(LT) The elastic GPU to attach to the instance"
    type        = map(string)
    default     = null
}

variable web_elastic_inference_accelerator {
    description = "(LT) Configuration block containing an Elastic Inference Accelerator to attach to the instance"
    type        = map(string)
    default     = null
}

variable web_enclave_options {
    description = "(LT) Enable Nitro Enclaves on launched instances"
    type        = map(string)
    default     = null
}

variable web_hibernation_options {
    description = "(LT) The hibernation options for the instance"
    type        = map(string)
    default     = null
}

variable web_instance_market_options {
    description = "(LT) The market (purchasing) option for the instance"
    type        = any
    default     = null
}

variable web_license_specifications {
    description = "(LT) A list of license specifications to associate with"
    type        = map(string)
    default     = null
}

variable web_network_interfaces {
    description = "(LT) Customize network interfaces to be attached at instance boot time"
    type        = list(any)
    default     = null
}

variable web_placement {
    description = "(LT) The placement of the instance"
    type        = map(string)
    default     = null
}

variable web_auto_scale_lt_tags {
    type        = map
    default     = {}
}

################################################################################
# WAS Load Balancer
################################################################################
variable was_load_balancer {
    type    = string
}

variable was_load_balancer_tags {
    type = map
    default = {}
}

variable was_lb_internal {
    description = "Boolean determining if the load balancer is internal or externally facing."
    type        = bool
    default     = true
}

variable was_load_balancer_type {
    type    = string
    default = null
}

variable was_lb_security_group {
    type    = any
    default = null
}

variable was_prev_step {
    type    = bool
    default = true
}

variable was_lb_drop_invalid_header_fields {
    description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false)."
    type    = bool
    default = false
}

variable was_lb_access_logs {
    description = "An Access Logs block. Access Logs documented below."
    type    = any
    default = null
}

variable was_subnet_mapping {
    description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
    type        = list
    default     = []
}

variable was_lb_deletion_protection {
    type    = bool
    default = false
}

variable was_lb_idle_timeout {
    description = "The time in seconds that the connection is allowed to be idle."
    type        = number
    default     = 60
}

variable was_lb_cross_zone_load_balancing {
    description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
    type        = bool
    default     = false
}

variable was_lb_http2 {
    description = "Indicates whether HTTP/2 is enabled in application load balancers."
    type        = bool
    default     = true
}

variable was_lb_ip_address_type {
    type    = string
    default = "ipv4"
}

variable was_load_balancer_create_timeout {
    description = "Timeout value when creating the ALB."
    type        = string
    default     = "15m"
}

variable was_load_balancer_update_timeout {
    description = "Timeout value when updating the ALB."
    type        = string
    default     = "15m"
}

variable was_load_balancer_delete_timeout {
    description = "Timeout value when deleting the ALB."
    type        = string
    default     = "15m"
}

################################################################################
#  WAS Load Balancer Listener
################################################################################

variable was_lb_listener {
    description = "Load Balancer Listener resource."
    type        = any
}

################################################################################
#  WAS Target Group
################################################################################

variable was_target_group {
    description = "Name of the target group."
    type        = string
}

variable was_target_group_tags {
    type        = map
    default     = {}
}

variable was_target_type {
    description = "Type of target that you must specify when registering targets with this target group."
    type        = string
    default     = "instance"
}

variable was_deregistration_delay {
    description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
    type        = number
    default     = 300
}

variable was_slow_start {
    description = "Amount time for targets to warm up before the load balancer sends them a full share of requests."
    type        = number
    default     = 0
}

variable was_load_balancing_algorithm_type {
    description = "Determines how the load balancer selects targets when routing requests."
    type        = string
    default     = "round_robin"
}

variable was_target_port {
    description = "Port on which targets receive traffic, unless overridden when registering a specific target."
    type        = number
}

variable was_target_protocol {
    description = "Protocol to use for routing traffic to the targets."
    type        = string
}

variable was_proxy_protocol_v2 {
    description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
    type        = bool
    default     = false
}

variable was_healthy_threshold {
    description = "Number of consecutive health checks successes required before considering an unhealthy target healthy."
    type        = number
    default     = 3
}

variable was_unhealthy_threshold {
    description = "Number of consecutive health check failures required before considering the target unhealthy."
    type        = number
    default     = 3
}

variable was_health_interval {
    description = "Approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
    type        = number
    default     = 30
}

variable was_health_port {
    description = "Port to use to connect with the target."
    type        = string
    default     = "traffic-port"
}

variable was_health_timeout {
    description = "Amount of time, in seconds, during which no response means a failed health check."
    type        = number
    default     = 5
}

variable was_health_matcher {
    description = "Response codes to use when checking for a healthy responses from a target."
    type        = string
    default     = "200"
}

variable was_health_path {
    description = "Destination for the health check request."
    type        = string
    default     = "/"
}

variable was_stickiness_enabled {
    description = "Whether to enable stickiness"
    type        = bool
    default     = false
}

variable was_cookie_duration {
    description = "The time period, in seconds, during which requests from a client should be routed to the same target."
    type        = number
    default     = 86400
}

################################################################################
# WAS Autoscaling group
################################################################################
variable was_auto_scale_group_name {
    description = "Name used across the resources created"
    type        = string
}

variable was_auto_scale_group_tags {
    type        = map
    default     = {}
}

variable was_min_size {
    description = "The minimum size of the autoscaling group"
    type        = number
    default     = null
}
variable was_max_size {
    description = "The maximum size of the autoscaling group"
    type        = number
    default     = null
}

variable was_desired_capacity {
    description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
    type        = number
    default     = null
}

variable was_capacity_rebalance {
    description = "Indicates whether capacity rebalance is enabled"
    type        = bool
    default     = true
}

variable was_min_elb_capacity {
    description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
    type        = number
    default     = null
}

variable was_wait_for_elb_capacity {
    description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
    type        = number
    default     = null
}

variable was_wait_for_capacity_timeout {
    description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
    type        = string
    default     = 0
}

variable was_default_cooldown {
    description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
    type        = number
    default     = null
}

variable was_protect_from_scale_in {
    description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
    type        = bool
    default     = false
}

variable was_target_group_arns {
    description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
    type        = list(string)
    default     = []
}

variable was_placement_group {
    description = "The name of the placement group into which you'll launch your instances, if any"
    type        = string
    default     = null
}

variable was_health_check_type {
    description = "`EC2` or `ELB`. Controls how health checking is done"
    type        = string
    default     = "ELB"
}

variable was_health_check_grace_period {
    description = "Time (in seconds) after instance comes into service before checking health"
    type        = number
    default     = null
}

variable was_force_delete {
    description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
    type        = bool
    default     = null
}

variable was_termination_policies {
    description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
    type        = list(string)
    default     = null
}

variable was_suspended_processes {
    description = "A list of processes to suspend for the Auto Scaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your Auto Scaling Group from functioning properly"
    type        = list(string)
    default     = null
}

variable was_max_instance_lifetime {
    description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds"
    type        = number
    default     = null
}

variable was_enabled_metrics {
    description = "A list of metrics to collect. The allowed values are `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"
    type        = list(string)
    default     = null
}

variable was_metrics_granularity {
    description = "The granularity to associate with the metrics to collect. The only valid value is `1Minute`"
    type        = string
    default     = null
}

variable was_service_linked_role_arn {
    description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
    type        = string
    default     = null
}

variable was_initial_lifecycle_hooks {
    description = "One or more Lifecycle Hooks to attach to the Auto Scaling Group before instances are launched. The syntax is exactly the same as the separate `aws_autoscaling_lifecycle_hook` resource, without the `autoscaling_group_name` attribute. Please note that this will only work when creating a new Auto Scaling Group. For all other use-cases, please use `aws_autoscaling_lifecycle_hook` resource"
    type        = list(map(string))
    default     = []
}

variable was_instance_refresh {
    description = "If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated"
    type        = any
    default     = null
}

variable was_use_mixed_instances_policy {
    description = "Determines whether to use a mixed instances policy in the autoscaling group or not"
    type        = bool
    default     = false
}

variable was_mixed_instances_policy {
    description = "Configuration block containing settings to define launch targets for Auto Scaling groups"
    type        = any
    default     = null
}

variable was_delete_timeout {
    description = "Delete timeout to wait for destroying autoscaling group"
    type        = string
    default     = null
}

variable was_warm_pool {
    description = "If this block is configured, add a Warm Pool to the specified Auto Scaling group."
    type        = any
    default     = null
}

################################################################################
# WAS Common - launch configuration or launch template
################################################################################

variable was_ebs_optimized {
    description = "If true, the launched EC2 instance will be EBS-optimized"
    type        = bool
    default     = true
}

variable was_iam_instance_profile_name {
    description = "The name attribute of the IAM instance profile to associate with launched instances"
    type        = string
    default     = null
}

variable was_iam_instance_profile_arn {
    description = "The IAM Instance Profile ARN to launch the instance with launched instances"
    type        = string
    default     = null
}

variable was_key_name {
    description = "The key name that should be used for the instance"
    type        = string
    default     = null
}

variable was_user_data {
    description = "The Base64-encoded user data to provide when launching the instance"
    type        = string
    default     = null
}

variable was_enable_monitoring {
    description = "Enables/disables detailed monitoring"
    type        = bool
    default     = true
}

variable was_metadata_options {
    description = "Customize the metadata options for the instance"
    type        = map(string)
    default     = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 32
    }
}

variable was_instance_ami {
    type    = string
    default = "ami-00f1068284b9eca92"
}

variable was_instance_type {
    description = "The type of the instance to launch"
    type        = string
    default     = "t3.large"
}

variable was_security_group_ids {
    description = "A list of security group IDs to associate with"
    type        = list(string)
    default     = null
}

variable was_security_group {
    type        = any
    default     = null
}

################################################################################
# WAS Launch configuration
################################################################################

variable was_auto_scale_lc_name {
    description = "Name used across the resources created"
    type        = string
    default     = null
}

variable was_associate_public_ip_address {
    description = "(LC) Associate a public ip address with an instance in a VPC"
    type        = bool
    default     = false
}

variable was_root_block_device {
    description = "(LC) Customize details about the root block device of the instance"
    type        = list(map(string))
    default     = []
}

variable was_ebs_block_device {
    description = "(LC) Additional EBS block devices to attach to the instance"
    type        = list(map(string))
    default     = []
}

variable was_spot_price {
    description = "(LC) The maximum price to use for reserving spot instances (defaults to on-demand price)"
    type        = string
    default     = "0.014"
}

variable was_placement_tenancy {
    description = "(LC) The tenancy of the instance. Valid values are `default` or `dedicated`"
    type        = string
    default     = null
}

variable was_ephemeral_block_device {
    description = "(LC) Customize Ephemeral (also known as 'Instance Store') volumes on the instance"
    type        = list(map(string))
    default     = []
}

################################################################################
# WAS Launch template
################################################################################
variable was_auto_scale_lt_name {
    description = "(LT) Name used across the resources created"
    type        = string
    default     = null
}

variable was_auto_scale_lt_description {
    type        = string
    default     = null
}

variable was_default_version {
    description = "(LT) Default Version of the launch template"
    type        = string
    default     = null
}

variable was_update_default_version {
    description = "(LT) Whether to update Default Version each update. Conflicts with `default_version`"
    type        = string
    default     = null
}

variable was_disable_api_termination {
    description = "(LT) If true, enables EC2 instance termination protection"
    type        = bool
    default     = null
}

variable was_instance_initiated_shutdown_behavior {
    description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
    type        = string
    default     = null
}

variable was_kernel_id {
    description = "(LT) The kernel ID"
    type        = string
    default     = null
}

variable was_ram_disk_id {
    description = "(LT) The ID of the ram disk"
    type        = string
    default     = null
}

variable was_block_device_mappings {
    description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
    type        = list(any)
    default     = []
}

variable was_capacity_reservation_specification {
    description = "(LT) Targeting for EC2 capacity reservations"
    type        = any
    default     = null
}

variable was_cpu_options {
    description = "(LT) The CPU options for the instance"
    type        = map(string)
    default     = null
}

variable was_credit_specification {
    description = "(LT) Customize the credit specification of the instance"
    type        = map(string)
    default     = null
}

variable was_elastic_gpu_specifications {
    description = "(LT) The elastic GPU to attach to the instance"
    type        = map(string)
    default     = null
}

variable was_elastic_inference_accelerator {
    description = "(LT) Configuration block containing an Elastic Inference Accelerator to attach to the instance"
    type        = map(string)
    default     = null
}

variable was_enclave_options {
    description = "(LT) Enable Nitro Enclaves on launched instances"
    type        = map(string)
    default     = null
}

variable was_hibernation_options {
    description = "(LT) The hibernation options for the instance"
    type        = map(string)
    default     = null
}

variable was_instance_market_options {
    description = "(LT) The market (purchasing) option for the instance"
    type        = any
    default     = null
}

variable was_license_specifications {
    description = "(LT) A list of license specifications to associate with"
    type        = map(string)
    default     = null
}

variable was_network_interfaces {
    description = "(LT) Customize network interfaces to be attached at instance boot time"
    type        = list(any)
    default     = null
}

variable was_placement {
    description = "(LT) The placement of the instance"
    type        = map(string)
    default     = null
}

variable was_auto_scale_lt_tags {
    type        = map
    default     = {}
}

################################################################################
# DB Random Password
################################################################################
variable db_name_user {
    description = "DB Username of parameter store"
    type        = string
    default     = ""
}

variable parameter_store_name {
    description = "Name of parameter store for RDS Master username"
    type        = string
    default     = "" 
}

variable parameter_store_tags {
    type = map
    default = {}
}

################################################################################
# Enhanced Monitoring
################################################################################
variable monitoring_role_name {
    description = "The name for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
    type        = string
    default     = null
}

variable monitoring_role_tags {
    type = map
    default = {}
}

################################################################################
# DB Subnet
################################################################################
variable db_subnet_group_name {
    description = "A DB subnet group to associate with this DB instance"
    type        = string
    default      = null
}

variable db_subnet_group_tags {
    type = map
    default = {}
}

################################################################################
# DB Option group
################################################################################
variable option_group_name {
    description = "Name of the option group"
    type        = string
    default     = null
}

variable option_group_tags {
    type = map
    default = {}
}

variable option_engine_version {
    description = "Specifies the major version of the engine that this option group should be associated(5.6, 5.7, 8.0)"
    type        = string
    default     = "10.3"
}

variable db_options {
    description = "A list of option to apply"
    type        = any
    default     = []
}

################################################################################
# DB Parameter group
################################################################################
variable parameter_group_name {
    description = "Name of the DB parameter group to create"
    type        = string
    default     = null
}

variable parameter_group_tags {
    type = map
    default = {}
}

variable parameter_family {
    description = "The family of the DB parameter group (mysql5.6, mysql5.7, mysql8.0)"
    type        = string
    default     = "mariadb10.3"
}

variable db_parameters {
    description = "A list of DB parameters(map) to apply"
    type        = list(map(string))
    default     = [
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

################################################################################
# RDS instance
################################################################################
variable rds_security_group {
    type    = any
    default = null
}

variable database_name {
    description = "The DB name to create. If omitted, no database is created initially"
    type        = string
    default     = null
}

variable database_tags {
    type = map
    default = {}
}

variable identifier {
    description = "The name of the RDS instance, if ommitted, Terraform will assign a random, unique identifier"
    type        = string
    default     = ""
}

variable engine_version {
    description = "The engine version to use"
    type        = string
    default     = "10.3.20"
}

variable db_port {
    description = "The port on which the DB accepts connections"
    type    = string
    default = "3306"
}

variable instance_class {
    description = "The instance type of the RDS instance"
    type        = string
    default     = ""
}

variable storage_type {
    description = "One of 'standard'(magnetic), 'gp2', or 'io1'. The default is io1 if iops is specified, gp2 if not."
    type        = string
    default     = "gp2"
}

variable iops {
    description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
    type        = number
    default     = 0
}

variable allocated_storage {
    description = "The allocated storage in gigabytes"
    type        = number
    default     = 20
}

variable max_allocated_storage {
    description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
    type        = number
    default     = 100
}

variable storage_encrypted {
    description = "Specifies whether the DB instance is encryped"
    type        = bool
    default     = true
}

variable kms_key_id {
    description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
    type        = string
    default     = ""
}

variable publicly_accessible {
    description = "Bool to control if instance is publicly accessible"
    type        = bool
    default     = false
}

variable multi_az {
    description = "Specifies if the RDS instance is multi-AZ"
    type        = bool
    default     = true
}

variable db_deletion_protection {
    description = "The database can't be deleted when this value is set to true"
    type        = bool
    default     = false
}

variable username {
    description = "Username for the master DB user"
    type        = string
    default     = ""
}

variable apply_immediately {
    description = "Specifies whether any database modifications are applied immediately or during the next maintenance window"
    type        = bool
    default     = true
}

variable allow_major_version_upgrade {
    description = "Indicates the major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
    type        = bool
    default     = false
}

variable auto_minor_version_upgrade {
    description = "Indicates that minor engine upgrades will be applied automatically during the maintenance window"
    type        = bool
    default     = false
}

variable maintenance_window {
    description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
    type        = string
    default     = "mon:15:00-mon:16:30"
}

variable backup_window {
    description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window"
    type        = string
    default     = "17:00-19:00"
}

variable backup_retention_period {
    description = "The days to retain backups for (0~35)"
    type        = number
    default     = 35
}

variable delete_automated_backups {
    description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
    type        = bool
    default     = true
}

variable enabled_cloudwatch_logs_exports {
    description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine)"
    type        = list(string)
    default     = ["audit", "error", "general", "slowquery"]
}

variable monitoring_interval {
    description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
    type        = number
    default     = 60
}

variable performance_insights_enabled {
    description = "Specifies whether Performance Insights are enabled"
    type        = bool
    default     = true
}

variable performance_insights_retention_period {
    description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
    type        = number
    default     = 7
}

variable copy_tags_to_snapshot {
    description = "Copy all instance tags to snapshot. Default is false"
    type        = bool
    default     = false
}

variable skip_final_snapshot {
    description = "Determine whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DB Snapshot is created"
    type        = bool
    default     = true
}

variable final_snapshot_identifier {
    description = "The name of your final DB snapshot when this DB instance is deleted. Must be provided if skip_final_snapshot is set to false."
    type        = string
    default     = null
}

################################################################################
# Common
################################################################################

variable aws_region {
    type    = string
    default = "ap-northeast-2"
}

variable vpc_id {
    type = string
}

variable web_subnet_ids {
    type = list
}

variable was_subnet_ids {
    type = list
}

variable db_subnet_ids {
    type = list
}