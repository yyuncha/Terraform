resource "aws_network_acl" "network_acl" {
    count       = length(var.network_acl)
    vpc_id      = aws_vpc.vpc.id
    tags        = merge(var.default_tags, { Name = var.network_acl[count.index].name })

    subnet_ids = [
        for subnet in var.network_acl[count.index].subnets:
            lookup(aws_subnet.private_subnet, subnet, lookup(aws_subnet.public_subnet, subnet, "")).id
    ]

    dynamic "ingress" {
        for_each = toset(var.network_acl[count.index].ingress)
        content {
            rule_no    = ingress.value[0]
            protocol   = ingress.value[1]
            from_port  = ingress.value[2]
            to_port    = ingress.value[3]
            cidr_block = ingress.value[4]
            action     = ingress.value[5]
        }
    }

    dynamic "egress" {
        for_each = toset(var.network_acl[count.index].egress)
        content {
            rule_no    = egress.value[0]
            protocol   = egress.value[1]
            from_port  = egress.value[2]
            to_port    = egress.value[3]
            cidr_block = egress.value[4]
            action     = egress.value[5]
        }
    }

    depends_on = [
        aws_vpc.vpc,
        aws_subnet.private_subnet,
        aws_subnet.public_subnet
    ]
}