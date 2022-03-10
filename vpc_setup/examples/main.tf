locals {
  aws_region   = "ap-northeast-2"
  resource_loc = "TEST-AN2-SHD"
}

provider "aws" {
  region = local.aws_region
}

module "vpc_setup" {
    source = "../"

    default_tags = {
        Env = "Sandbox"
        managed = "no"
    }

    vpc = {
        name = "${local.resource_loc}-vpc"
        cidr_block = "10.0.0.0/16"
        secondary_cidr_blocks = [
            "10.10.0.0/16"
        ]
    }

    public_subnets = {
        Public_1 = ["ap-northeast-2a", "10.0.0.0/24", "${local.resource_loc}-SBN-EXT-1"]
        Public_2 = ["ap-northeast-2c", "10.0.1.0/24", "${local.resource_loc}-SBN-EXT-2"]
    }

    private_subnets = {
        AP_1 = ["ap-northeast-2a", "10.0.2.0/24", "${local.resource_loc}-SBN-AP-1"]
        AP_2 = ["ap-northeast-2c", "10.0.3.0/24", "${local.resource_loc}-SBN-AP-2"]
        DB_1 = ["ap-northeast-2a", "10.0.4.0/24", "${local.resource_loc}-SBN-DB-1"]
        DB_2 = ["ap-northeast-2c", "10.0.5.0/24", "${local.resource_loc}-SBN-DB-2"]
    }

    nat_gateway = {
        name = "${local.resource_loc}-NATGW"
        subnet = "Public_1"
    }

    public_route_table = "${local.resource_loc}-RT-PUB"
    private_route_table = "${local.resource_loc}-RT-PRV"   
    
    network_acl = [
        {   
            name = "${local.resource_loc}-NACL-AP"
            subnets = ["AP_1", "AP_2"]
            ingress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
            egress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
        },
        {   
            name = "${local.resource_loc}-NACL-DB"
            subnets = ["DB_1", "DB_2"]
            ingress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
            egress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
        },
        {   
            name = "${local.resource_loc}-NACL-EXT"
            subnets = ["Public_1", "Public_2"]
            ingress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
            egress = [
                [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
            ]
        }
    ]
}