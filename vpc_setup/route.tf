resource "aws_route_table" "public_route_table" {
    count       = length(local.public_route_table) == 0 ? 0 : 1

    vpc_id      = aws_vpc.vpc.id
    tags        = merge(var.default_tags, { Name = var.public_route_table })

    route {
        cidr_block      = "0.0.0.0/0"
        gateway_id      = aws_internet_gateway.internet_gateway[0].id
    }

    depends_on = [
        aws_vpc.vpc,
        aws_internet_gateway.internet_gateway
    ]
}

resource "aws_route_table_association" "public_route_table" {
    for_each        = aws_subnet.public_subnet
    subnet_id       = aws_subnet.public_subnet[each.key].id
    route_table_id  = aws_route_table.public_route_table[0].id
}

resource "aws_route_table" "private_route_table" {
    vpc_id      = aws_vpc.vpc.id
    tags        = merge(var.default_tags, { Name = var.private_route_table })

    dynamic "route" {
        for_each = var.public_subnets == null ? [] : [true]
        content {
            cidr_block      = "0.0.0.0/0"
            nat_gateway_id  = aws_nat_gateway.nat_gateway[0].id
        }
    }

    depends_on = [
        aws_vpc.vpc,
        aws_nat_gateway.nat_gateway
    ]
}

resource "aws_route_table_association" "private_route_table" {
    for_each        = aws_subnet.private_subnet
    subnet_id       = aws_subnet.private_subnet[each.key].id
    route_table_id  = aws_route_table.private_route_table.id
}