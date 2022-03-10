variable default_tags {
    type        = map
    description = "default tags"
    default     = {}
}

variable vpc {
    type        = any
    description = "Provides a VPC resource."
}

variable internet_gateway {
    type        = string
    description = "Provides a resource to create a VPC Internet Gateway."
    default     = "internet_gateway"
}

variable public_subnets {
    type = map
    default = null
    description = "Provides an VPC public subnet resource."
}

variable private_subnets {
    type = map
    default = null
    description = "Provides an VPC private subnet resource."
}

variable nat_eip {
    type        = string
    description = "Provides an Elastic IP resource for NAT Gateway."
    default     = "nat_eip"
}

variable nat_gateway {
    type        = map
    description = "Provides a resource to create a VPC NAT Gateway."
    default     = null
}

variable public_route_table {
    type        = string
    description = "Provides a resource to create a VPC public routing table."
    default     = "public_route_table"
}

variable private_route_table {
    type        = string
    description = "Provides a resource to create a VPC private routing table."
    default     = "private_route_table"
}

variable network_acl {
    type        = any
    description = "Provides an network ACL resource."
    default     = []
}

variable endpoint_security_group {
    type        = string
    description = "Security Group for VPC endpoint"
    default     = "endpoint_security_group"
}

variable endpoint_subnets {
    type        = list
    description = "VPC subnet for VPC endpoint location"
    default     = null
}

variable vpc_endpoint_ssm {
    type        = string
    description = "VPC endpoint (ssm)"
    default     = "vpc_endpoint_ssm"
}

variable vpc_endpoint_s3 {
    type        = string
    description = "VPC endpoint (S3)"
    default     = "vpc_endpoint_s3"
}

variable vpc_endpoint_ec2messages {
    type        = string
    description = "VPC endpoint (ec2messages)"
    default     = "vpc_endpoint_ec2messages"
}

variable vpc_endpoint_ssmmessages {
    type        = string
    description = "VPC endpoint (ssmmessages)"
    default     = "vpc_endpoint_ssmmessages"
}