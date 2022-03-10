resource "aws_security_group" "lb_security_group" {
    count = var.load_balancer_type == "application" ? 1 : 0

    name        = var.lb_security_group.name
    description = lookup(var.lb_security_group, "description", null)
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = var.lb_security_group.ingress
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
        for_each = var.lb_security_group.egress
        content {
            description      = lookup(egress.value, "description", null)
            from_port        = lookup(egress.value, "from_port", null)
            to_port          = lookup(egress.value, "to_port", null)
            protocol         = lookup(egress.value, "protocol", null)
            cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
            ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
        }
    }

    tags = merge({ Name = var.lb_security_group.name }, lookup(var.lb_security_group, "tags", {}))
}

resource "aws_security_group_rule" "allow_from_prev_step" {
    count = var.prev_step ? 1 : 0

    type              = "ingress"
    to_port           = var.prev_port
    protocol          = lower(var.prev_protocol) == "http" || lower(var.prev_protocol) == "https" ? "tcp" : var.prev_protocol
    from_port         = var.prev_port
    security_group_id = aws_security_group.lb_security_group[0].id
    source_security_group_id       = var.prev_security_group

    depends_on = [
        aws_security_group.lb_security_group
    ]
}

resource "aws_security_group_rule" "allow_to_load_balancer" {
    count = var.prev_step ? 1 : 0

    type              = "egress"
    to_port           = var.prev_port
    protocol          = lower(var.prev_protocol) == "http" || lower(var.prev_protocol) == "https" ? "tcp" : var.prev_protocol
    from_port         = var.prev_port
    security_group_id = var.prev_security_group
    source_security_group_id       = aws_security_group.lb_security_group[0].id

    depends_on = [
        aws_security_group.lb_security_group
    ]
}