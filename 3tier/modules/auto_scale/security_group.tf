resource "aws_security_group" "ap_security_group" {
    count = var.ap_security_group != null ? 1 : 0

    name        = var.ap_security_group.name
    description = lookup(var.ap_security_group, "description", null)
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = var.ap_security_group.ingress
        content {
            description      = lookup(ingress.value, "description", null)
            from_port        = lookup(ingress.value, "from_port", null)
            to_port          = lookup(ingress.value, "to_port", null)
            protocol         = lookup(ingress.value, "protocol", null)
            cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
            ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
        }
    }

    dynamic "egress" {
        for_each = var.ap_security_group.egress
        content {
            description      = lookup(egress.value, "description", null)
            from_port        = lookup(egress.value, "from_port", null)
            to_port          = lookup(egress.value, "to_port", null)
            protocol         = lookup(egress.value, "protocol", null)
            cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
            ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
        }
    }

    tags = merge({ Name = var.ap_security_group.name }, lookup(var.ap_security_group, "tags", {}))
}

resource "aws_security_group_rule" "allow_from_load_balancer" {
    count = var.load_balancer_type == "application" ? 1 : 0

    type              = "ingress"
    to_port           = var.lb_target_port
    protocol          = lower(var.lb_target_protocol) == "http" || lower(var.lb_target_protocol) == "https" ? "tcp" : var.lb_target_protocol
    from_port         = var.lb_target_port
    security_group_id = var.ap_security_group != null ? aws_security_group.ap_security_group[0].id : var.security_group_ids[0]
    source_security_group_id       = var.lb_security_group

    depends_on = [
        aws_security_group.ap_security_group
    ]
}

resource "aws_security_group_rule" "allow_to_autoscaling_group" {
    count = var.load_balancer_type == "application" ? 1 : 0

    type              = "egress"
    to_port           = var.lb_target_port
    protocol          = lower(var.lb_target_protocol) == "http" || lower(var.lb_target_protocol) == "https" ? "tcp" : var.lb_target_protocol
    from_port         = var.lb_target_port
    security_group_id = var.lb_security_group
    source_security_group_id       = var.ap_security_group != null ? aws_security_group.ap_security_group[0].id : var.security_group_ids[0]

    depends_on = [
        aws_security_group.ap_security_group
    ]
}