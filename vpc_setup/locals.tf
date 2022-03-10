locals {
    internet_gateway    = var.public_subnets == null ? 0 : 1
    public_subnets      = var.public_subnets == null ? {} : var.public_subnets
    nat_gateway         = var.public_subnets == null ? {} : (
        var.nat_gateway == null ? {
            name = "default" 
            subnet = keys(local.public_subnets)[0]
        } : var.nat_gateway
    )

    public_route_table  = var.public_subnets == null ? "" : var.public_route_table

    az_list = distinct(flatten([
        for i in values(merge(var.public_subnets, var.private_subnets)): [
            i[0]
        ]
    ]))

    endpoint_subnets    = var.endpoint_subnets != null ? var.endpoint_subnets : [
        for az in local.az_list: compact([
            for key, subnet in var.private_subnets:
                subnet[0] == az ? key : ""
        ])[0]
    ]
}