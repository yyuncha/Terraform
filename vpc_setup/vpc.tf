resource "aws_vpc" "vpc" {
    cidr_block              = var.vpc.cidr_block
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags                    = merge(var.default_tags, { Name = var.vpc.name })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
    count       = length(var.vpc.secondary_cidr_blocks) > 0 ? length(var.vpc.secondary_cidr_blocks) : 0
    vpc_id      = aws_vpc.vpc.id
    cidr_block  = var.vpc.secondary_cidr_blocks[count.index]

    depends_on  = [
        aws_vpc.vpc
    ]
}

resource "aws_subnet" "public_subnet" {
    for_each            = local.public_subnets
    availability_zone   = each.value[0]
    cidr_block          = each.value[1]
    vpc_id              = aws_vpc.vpc.id
    tags                = merge(var.default_tags, { Name = each.value[2] })

    depends_on          = [
        aws_vpc.vpc,
        aws_vpc_ipv4_cidr_block_association.secondary_cidr
    ]
}

resource "aws_subnet" "private_subnet" {
    for_each            = var.private_subnets
    availability_zone   = each.value[0]
    cidr_block          = each.value[1]
    vpc_id              = aws_vpc.vpc.id
    tags                = merge(var.default_tags, { Name = each.value[2] })

    depends_on          = [
        aws_vpc.vpc,
        aws_vpc_ipv4_cidr_block_association.secondary_cidr
    ]
}

resource "aws_internet_gateway" "internet_gateway" {
    count               = local.internet_gateway
    vpc_id              = aws_vpc.vpc.id
    tags                = merge(var.default_tags, { Name = var.internet_gateway })

    depends_on          = [
        aws_vpc.vpc
    ]
}

resource "aws_eip" "nat_eip" {
    count               = length(local.nat_gateway) != 0 ? 1 : 0
    vpc                 = true
    tags                = merge(var.default_tags, { Name = var.nat_eip })

    depends_on          = [
        aws_vpc.vpc,
        aws_internet_gateway.internet_gateway
    ]
}

resource "aws_nat_gateway" "nat_gateway" {
    count               = length(local.nat_gateway) != 0 ? 1 : 0
    allocation_id       = aws_eip.nat_eip[0].id
    connectivity_type   = "public"
    subnet_id           = aws_subnet.public_subnet[local.nat_gateway.subnet].id
    tags                = merge(var.default_tags, { Name = local.nat_gateway.name })

    depends_on          = [
        aws_vpc.vpc,
        aws_subnet.public_subnet,
        aws_eip.nat_eip,
        aws_internet_gateway.internet_gateway
    ]
}