resource "aws_lb_target_group" "target_group" {
    name        = var.target_group
    target_type = var.target_type
    
    deregistration_delay    = var.deregistration_delay
    slow_start              = var.slow_start

    health_check {
        healthy_threshold   = var.healthy_threshold
        interval            = var.health_interval
        matcher             = var.load_balancer_type == "application" ? var.health_matcher : null
        path                = var.load_balancer_type == "application" ? var.health_path : null
        port                = var.health_port
        protocol            = var.target_protocol
        timeout             = var.health_timeout
        unhealthy_threshold = var.unhealthy_threshold
    }

    stickiness {
        cookie_duration     = var.load_balancer_type == "application" ? var.cookie_duration : null
        enabled             = var.stickiness_enabled
        type                = var.load_balancer_type == "application" ? "lb_cookie" : "source_ip"
    }

    load_balancing_algorithm_type   = var.load_balancer_type == "application" ? var.load_balancing_algorithm_type : null
    
    port                = var.target_port
    protocol            = var.target_protocol
    protocol_version    = var.load_balancer_type == "application" ? var.lb_http2 == "true" ? "HTTP2" : "HTTP1" : null
    proxy_protocol_v2   = var.load_balancer_type == "network" ? var.proxy_protocol_v2 : null
    vpc_id              = var.vpc_id

    tags = merge({ Name = var.target_group}, var.target_group_tags)
}