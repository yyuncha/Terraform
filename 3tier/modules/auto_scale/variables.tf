################################################################################
# Autoscaling group
################################################################################
variable auto_scale_group_name {
    description = "Name used across the resources created"
    type        = string
}

variable auto_scale_group_tags {
    type        = map
}

variable min_size {
    description = "The minimum size of the autoscaling group"
    type        = number
}
variable max_size {
    description = "The maximum size of the autoscaling group"
    type        = number
}

variable desired_capacity {
    description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
    type        = number
}

variable capacity_rebalance {
    description = "Indicates whether capacity rebalance is enabled"
    type        = bool
}

variable min_elb_capacity {
    description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
    type        = number
}

variable wait_for_elb_capacity {
    description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
    type        = number
}

variable wait_for_capacity_timeout {
    description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
    type        = string
}

variable default_cooldown {
    description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
    type        = number
}

variable protect_from_scale_in {
    description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
    type        = bool
}

variable target_group_arns {
    description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
    type        = list(string)
}

variable placement_group {
    description = "The name of the placement group into which you'll launch your instances, if any"
    type        = string
}

variable health_check_type {
    description = "`EC2` or `ELB`. Controls how health checking is done"
    type        = string
}

variable health_check_grace_period {
    description = "Time (in seconds) after instance comes into service before checking health"
    type        = number
}

variable force_delete {
    description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
    type        = bool
}

variable termination_policies {
    description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
    type        = list(string)
}

variable suspended_processes {
    description = "A list of processes to suspend for the Auto Scaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your Auto Scaling Group from functioning properly"
    type        = list(string)
}

variable max_instance_lifetime {
    description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds"
    type        = number
}

variable enabled_metrics {
    description = "A list of metrics to collect. The allowed values are `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"
    type        = list(string)
}

variable metrics_granularity {
    description = "The granularity to associate with the metrics to collect. The only valid value is `1Minute`"
    type        = string
}

variable service_linked_role_arn {
    description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
    type        = string
}

variable initial_lifecycle_hooks {
    description = "One or more Lifecycle Hooks to attach to the Auto Scaling Group before instances are launched. The syntax is exactly the same as the separate `aws_autoscaling_lifecycle_hook` resource, without the `autoscaling_group_name` attribute. Please note that this will only work when creating a new Auto Scaling Group. For all other use-cases, please use `aws_autoscaling_lifecycle_hook` resource"
    type        = list(map(string))
}

variable instance_refresh {
    description = "If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated"
    type        = any
}

variable use_mixed_instances_policy {
    description = "Determines whether to use a mixed instances policy in the autoscaling group or not"
    type        = bool
}

variable mixed_instances_policy {
    description = "Configuration block containing settings to define launch targets for Auto Scaling groups"
    type        = any
}

variable delete_timeout {
    description = "Delete timeout to wait for destroying autoscaling group"
    type        = string
}

variable warm_pool {
    description = "If this block is configured, add a Warm Pool to the specified Auto Scaling group."
    type        = any
}

################################################################################
# Common - launch configuration or launch template
################################################################################

variable ebs_optimized {
    description = "If true, the launched EC2 instance will be EBS-optimized"
    type        = bool
}

variable iam_instance_profile_name {
    description = "The name attribute of the IAM instance profile to associate with launched instances"
    type        = string
}

variable iam_instance_profile_arn {
    description = "The IAM Instance Profile ARN to launch the instance with launched instances"
    type        = string
}

variable key_name {
    description = "The key name that should be used for the instance"
    type        = string
}

variable user_data {
    description = "The Base64-encoded user data to provide when launching the instance"
    type        = string
}

variable enable_monitoring {
    description = "Enables/disables detailed monitoring"
    type        = bool
}

variable metadata_options {
    description = "Customize the metadata options for the instance"
    type        = map(string)
}

variable instance_ami {
    type    = string
}

variable instance_type {
    description = "The type of the instance to launch"
    type        = string

}

variable security_group_ids {
    description = "A list of security group IDs to associate with"
    type        = list(string)
}

variable ap_security_group {
    type        = any
}

variable lb_security_group {
    type        = any
}

variable lb_target_port {
    type        = number
}

variable lb_target_protocol {
    type        = string
}

variable load_balancer_type {
    type    = string
}

################################################################################
# Launch configuration
################################################################################

variable auto_scale_lc_name {
    description = "Name used across the resources created"
    type        = string
}

variable associate_public_ip_address {
    description = "(LC) Associate a public ip address with an instance in a VPC"
    type        = bool
}

variable root_block_device {
    description = "(LC) Customize details about the root block device of the instance"
    type        = list(map(string))
}

variable ebs_block_device {
    description = "(LC) Additional EBS block devices to attach to the instance"
    type        = list(map(string))
}

variable spot_price {
    description = "(LC) The maximum price to use for reserving spot instances (defaults to on-demand price)"
    type        = string
}

variable placement_tenancy {
    description = "(LC) The tenancy of the instance. Valid values are `default` or `dedicated`"
    type        = string
}

variable ephemeral_block_device {
    description = "(LC) Customize Ephemeral (also known as 'Instance Store') volumes on the instance"
    type        = list(map(string))
}

################################################################################
# Launch template
################################################################################
variable auto_scale_lt_name {
    description = "Name used across the resources created"
    type        = string
}

variable auto_scale_lt_description {
    type        = string
}

variable default_version {
    description = "(LT) Default Version of the launch template"
    type        = string
}

variable update_default_version {
    description = "(LT) Whether to update Default Version each update. Conflicts with `default_version`"
    type        = string
}

variable disable_api_termination {
    description = "(LT) If true, enables EC2 instance termination protection"
    type        = bool
}

variable instance_initiated_shutdown_behavior {
    description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
    type        = string
}

variable kernel_id {
    description = "(LT) The kernel ID"
    type        = string
}

variable ram_disk_id {
    description = "(LT) The ID of the ram disk"
    type        = string
}

variable block_device_mappings {
    description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
    type        = list(any)
}

variable capacity_reservation_specification {
    description = "(LT) Targeting for EC2 capacity reservations"
    type        = any
}

variable cpu_options {
    description = "(LT) The CPU options for the instance"
    type        = map(string)
}

variable credit_specification {
    description = "(LT) Customize the credit specification of the instance"
    type        = map(string)
}

variable elastic_gpu_specifications {
    description = "(LT) The elastic GPU to attach to the instance"
    type        = map(string)
}

variable elastic_inference_accelerator {
    description = "(LT) Configuration block containing an Elastic Inference Accelerator to attach to the instance"
    type        = map(string)
}

variable enclave_options {
    description = "(LT) Enable Nitro Enclaves on launched instances"
    type        = map(string)
}

variable hibernation_options {
    description = "(LT) The hibernation options for the instance"
    type        = map(string)
}

variable instance_market_options {
    description = "(LT) The market (purchasing) option for the instance"
    type        = any
}

variable license_specifications {
    description = "(LT) A list of license specifications to associate with"
    type        = map(string)
}

variable network_interfaces {
    description = "(LT) Customize network interfaces to be attached at instance boot time"
    type        = list(any)
}

variable placement {
    description = "(LT) The placement of the instance"
    type        = map(string)
}

variable auto_scale_lt_tags {
    type        = map
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

variable ap_subnet_ids {
    type = list
}
