################################################################################
# Security Group
################################################################################
resource "aws_security_group" "rds_security_group" {
    name        = var.rds_security_group.name
    description = lookup(var.rds_security_group, "description", null)
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = var.rds_security_group.ingress
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
        for_each = var.rds_security_group.egress
        content {
            description      = lookup(egress.value, "description", null)
            from_port        = lookup(egress.value, "from_port", null)
            to_port          = lookup(egress.value, "to_port", null)
            protocol         = lookup(egress.value, "protocol", null)
            cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
            ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
        }
    }

    tags = merge({ Name = var.rds_security_group.name }, lookup(var.rds_security_group, "tags", {}))
}

resource "aws_security_group_rule" "allow_from_autoscaling_group" {
    type              = "ingress"
    to_port           = var.db_port
    protocol          = "tcp"
    from_port         = var.db_port
    security_group_id = aws_security_group.rds_security_group.id
    source_security_group_id       = var.ap_security_group

    depends_on = [
        aws_security_group.rds_security_group
    ]
}

resource "aws_security_group_rule" "allow_to_rds_mariadb" {
    type              = "egress"
    to_port           = var.db_port
    protocol          = "tcp"
    from_port         = var.db_port
    security_group_id = var.ap_security_group
    source_security_group_id       = aws_security_group.rds_security_group.id

    depends_on = [
        aws_security_group.rds_security_group
    ]
}