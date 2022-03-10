################################################################################
# Load Balancer
################################################################################
variable load_balancer {
    type    = string
}

variable load_balancer_tags {
    type = map
}

variable lb_internal {
    description = "Boolean determining if the load balancer is internal or externally facing."
    type        = bool
}

variable load_balancer_type {
    type    = string
}

variable lb_security_group {
    type    = any
}

variable prev_step {
    type = bool
}

variable prev_security_group {
    default = null
    type = string
}

variable prev_port {
    default = null
    type = number
}

variable prev_protocol {
    default = null
    type = string
}

variable lb_drop_invalid_header_fields {
    type    = bool
}

variable lb_access_logs {
    type    = any
}

variable subnet_mapping {
    description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
    type        = list
}

variable lb_deletion_protection {
    type    = bool
}

variable lb_idle_timeout {
    description = "The time in seconds that the connection is allowed to be idle."
    type        = number
}

variable lb_cross_zone_load_balancing {
    description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
    type        = bool
}

variable lb_http2 {
    description = "Indicates whether HTTP/2 is enabled in application load balancers."
    type        = bool
}

variable lb_ip_address_type {
    type    = string
}

variable load_balancer_create_timeout {
    description = "Timeout value when creating the ALB."
    type        = string
}

variable load_balancer_update_timeout {
    description = "Timeout value when updating the ALB."
    type        = string
}

variable load_balancer_delete_timeout {
    description = "Timeout value when deleting the ALB."
    type        = string
}

################################################################################
#  Load Balancer Listener
################################################################################

variable lb_listener {
    description = "Load Balancer Listener resource."
    type        = any
}

################################################################################
#  Target Group
################################################################################

variable target_group {
    description = "Name of the target group."
    type        = string
}

variable target_group_tags {
    type        = map
}

variable target_type {
    description = "Type of target that you must specify when registering targets with this target group."
    type        = string
}

variable deregistration_delay {
    description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
    type        = number
}

variable slow_start {
    description = "Amount time for targets to warm up before the load balancer sends them a full share of requests."
    type        = number
}

variable load_balancing_algorithm_type {
    description = "Determines how the load balancer selects targets when routing requests."
    type        = string
}

variable target_port {
    description = "Port on which targets receive traffic, unless overridden when registering a specific target."
    type        = number
}

variable target_protocol {
    description = "Protocol to use for routing traffic to the targets."
    type        = string
}

variable proxy_protocol_v2 {
    description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
    type        = bool
}

variable healthy_threshold {
    description = "Number of consecutive health checks successes required before considering an unhealthy target healthy."
    type        = number
}

variable unhealthy_threshold {
    description = "Number of consecutive health check failures required before considering the target unhealthy."
    type        = number
}

variable health_interval {
    description = " Approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
    type        = number
}

variable health_port {
    description = "Port to use to connect with the target."
    type        = string
}

variable health_timeout {
    description = "Amount of time, in seconds, during which no response means a failed health check."
    type        = number
}

variable health_matcher {
    description = "Response codes to use when checking for a healthy responses from a target."
    type        = string
}

variable health_path {
    description = "Destination for the health check request."
    type        = string
}

variable stickiness_enabled {
    description = "Whether to enable stickiness"
    type        = bool
}

variable cookie_duration {
    description = "The time period, in seconds, during which requests from a client should be routed to the same target."
    type        = number
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