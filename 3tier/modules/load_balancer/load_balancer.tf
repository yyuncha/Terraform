################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "load_balancer" {
    name               = var.load_balancer
    internal           = var.lb_internal
    load_balancer_type = var.load_balancer_type
    security_groups    = var.load_balancer_type == "application" ? [aws_security_group.lb_security_group[0].id] : null

    drop_invalid_header_fields       = var.lb_drop_invalid_header_fields

    dynamic "access_logs" {
        for_each = var.lb_access_logs == null ? [] : [var.lb_access_logs]
        content {
            enabled = lookup(access_logs.value, "bucket", null) != null
            bucket  = lookup(access_logs.value, "bucket", null)
            prefix  = lookup(access_logs.value, "prefix", null)
        }
    }

    subnets            = var.ap_subnet_ids
/*
    dynamic "subnet_mapping" {
        for_each = local.subnet_mapping

        content {
            subnet_id     = subnet_mapping.value.subnet_id
            allocation_id = lookup(subnet_mapping.value, "allocation_id", null)
        }
    }
*/
    idle_timeout                     = var.lb_idle_timeout
    enable_deletion_protection       = var.lb_deletion_protection
    enable_cross_zone_load_balancing = var.lb_cross_zone_load_balancing

    enable_http2                     = var.lb_http2
    ip_address_type                  = var.lb_ip_address_type

    tags = merge({ Name = var.load_balancer }, var.load_balancer_tags)
    
    timeouts {
        create = var.load_balancer_create_timeout
        update = var.load_balancer_update_timeout
        delete = var.load_balancer_delete_timeout
    }

    depends_on = [
        aws_security_group.lb_security_group
    ]
}

################################################################################
#  Load Balancer Listener
################################################################################

resource "aws_lb_listener" "lb_listener" {
    count = length(var.lb_listener)

    load_balancer_arn   = aws_lb.load_balancer.arn
    
    port                = var.lb_listener[count.index].port
    protocol            = var.lb_listener[count.index].protocol
    certificate_arn     = var.lb_listener[count.index].protocol == "HTTPS" || var.lb_listener[count.index].protocol == "TLS" ?  lookup(var.lb_listener[count.index], "certificate_arn", null) : null
    ssl_policy          = var.lb_listener[count.index].protocol == "HTTPS" || var.lb_listener[count.index].protocol == "TLS" ?  lookup(var.lb_listener[count.index], "ssl_policy", null) : null
    alpn_policy         = var.lb_listener[count.index].protocol == "TLS" ? lookup(var.lb_listener[count.index], "alpn_policy", null) : null

    default_action {
        type = var.lb_listener[count.index].default_action.type

        dynamic "redirect" {
            for_each = var.lb_listener[count.index].default_action.type == "redirect" ? [true] : []
            content {
                status_code = var.lb_listener[count.index].default_action.status_code
                host        = lookup(var.lb_listener[count.index].default_action, "host", null)
                path        = lookup(var.lb_listener[count.index].default_action, "path", null)
                port        = lookup(var.lb_listener[count.index].default_action, "port", null)
                protocol    = lookup(var.lb_listener[count.index].default_action, "protocol", null)
                query       = lookup(var.lb_listener[count.index].default_action, "query", null)
            }
        }

        dynamic "forward" {
            for_each = var.lb_listener[count.index].default_action.type == "forward" ? [true] : []
            content {
                target_group {
                    arn = aws_lb_target_group.target_group.arn
                    weight = lookup(var.lb_listener[count.index].default_action, "weigth", null)
                }
                stickiness {
                    enabled = lookup(var.lb_listener[count.index].default_action, "stickiness", false)
                    duration = lookup(var.lb_listener[count.index].default_action, "duration", "5")
                }
            }
        }

        dynamic "fixed_response" {
            for_each = var.lb_listener[count.index].default_action.type == "fixed_response" ? [true] : []
            content {
                content_type    = var.lb_listener[count.index].default_action.content_type
                message_body    = lookup(var.lb_listener[count.index].default_action, "message_body", null)
                status_code     = lookup(var.lb_listener[count.index].default_action, "status_code", null)
            }
        }
    }

    depends_on = [
        aws_lb.load_balancer,
        aws_lb_target_group.target_group
    ]
}