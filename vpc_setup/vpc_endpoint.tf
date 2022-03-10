resource "aws_security_group" "vpc_endpoint_security_group" {
    name    = var.endpoint_security_group
    vpc_id  = aws_vpc.vpc.id
    tags    = merge(var.default_tags, { Name = var.endpoint_security_group })
    
    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    depends_on  = [
        aws_vpc.vpc
    ]
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
    vpc_id              = aws_vpc.vpc.id
    service_name        = "com.amazonaws.ap-northeast-2.s3"
    vpc_endpoint_type   = "Gateway"
    tags                = merge(var.default_tags, { Name = var.vpc_endpoint_s3 })

    route_table_ids     = [
        aws_route_table.private_route_table.id
    ]

    depends_on  = [
        aws_vpc.vpc,
        aws_route_table.private_route_table
     ]
}

resource "aws_vpc_endpoint" "vpc_endpoint_ssm" {
    vpc_id              = aws_vpc.vpc.id
    service_name        = "com.amazonaws.ap-northeast-2.ssm"
    vpc_endpoint_type   = "Interface"
    tags                = merge(var.default_tags, { Name = var.vpc_endpoint_ssm })

    security_group_ids  = [ aws_security_group.vpc_endpoint_security_group.id ]
    subnet_ids          = [ 
        for subnet in local.endpoint_subnets:
            lookup(aws_subnet.private_subnet, subnet, null).id
    ]

    private_dns_enabled = true
    
    depends_on = [
        aws_vpc.vpc,
        aws_subnet.private_subnet
     ]
}

resource "aws_vpc_endpoint" "vpc_endpoint_ec2messages" {
    vpc_id              = aws_vpc.vpc.id
    service_name        = "com.amazonaws.ap-northeast-2.ec2messages"
    vpc_endpoint_type   = "Interface"
    tags                = merge(var.default_tags, { Name = var.vpc_endpoint_ec2messages })

    security_group_ids  = [ aws_security_group.vpc_endpoint_security_group.id ]
    subnet_ids          = [ 
        for subnet in local.endpoint_subnets:
            lookup(aws_subnet.private_subnet, subnet, null).id
    ]

    private_dns_enabled = true
    
    depends_on = [
        aws_vpc.vpc,
        aws_subnet.private_subnet
     ]
}

resource "aws_vpc_endpoint" "vpc_endpoint_ssmmessages" {
    vpc_id              = aws_vpc.vpc.id
    service_name        = "com.amazonaws.ap-northeast-2.ssmmessages"
    vpc_endpoint_type   = "Interface"
    tags                = merge(var.default_tags, { Name = var.vpc_endpoint_ssmmessages })

    security_group_ids  = [ aws_security_group.vpc_endpoint_security_group.id ]
    subnet_ids          = [ 
        for subnet in local.endpoint_subnets:
            lookup(aws_subnet.private_subnet, subnet, null).id
    ]

    private_dns_enabled = true
    
    depends_on = [
        aws_vpc.vpc,
        aws_subnet.private_subnet
     ]
}