locals {
  resource_loc = "TEST-AN2-TEST"
}

# Case using Launch configuration
module "Three_tier" {
    source            = "../"
    aws_region        = "ap-northeast-2"
    vpc_id            = "vpc-02e545d5f5ade7b11"

    web_subnet_ids      = [
        "subnet-0c9d530b3e788242c",
        "subnet-0cdc0961201c12830"
    ]

    was_subnet_ids      = [
        "subnet-0042b576ae7d29d7f",
        "subnet-09ea3434d12723526"
    ]

    db_subnet_ids      = [
        "subnet-07b7516b737e6106e",
        "subnet-0b9e896e6f265b918"
    ]

    ################################################################################
    # WEB instance spec
    ################################################################################

    web_instance_ami       = "ami-06e6baaa837887cb1"
    web_instance_type      = "t3.micro"

    web_security_group = {
        name    = "${local.resource_loc}-SG-WEB-AS-3TIER"
        ingress = [
            {
                from_port        = 80
                to_port          = 80
                protocol         = "tcp"
                cidr_blocks      = ["10.0.0.0/16"]
            },
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
        egress = [
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
    }

    web_prev_step = false

    web_security_group_ids = ["sg-0aafd610bbd1bb9a4"]

    web_auto_scale_lc_name    = "${local.resource_loc}-WEB-AS-3TIER-LC"
    web_auto_scale_group_name = "${local.resource_loc}-WEB-AS-3TIER-GROUP"

    ################################################################################
    # WEB Launch configuration
    ################################################################################

    web_ebs_block_device = [
        {
        no_device             = 0
        device_name           = "/dev/xvdz"
        delete_on_termination = true
        encrypted             = true
        volume_type           = "gp2"
        volume_size           = "50"
        },
    ]

    web_root_block_device = [
        {
        delete_on_termination = true
        encrypted             = true
        volume_size           = "50"
        volume_type           = "gp2"
        },
    ]

    ################################################################################
    # WEB Autoscaling group
    ################################################################################

    web_min_size                  = 0
    web_max_size                  = 1
    web_desired_capacity          = 1

    ################################################################################
    # WEB Load Balancer
    ################################################################################

    web_load_balancer          = "${local.resource_loc}-WEB-LB-3TIER"
    web_load_balancer_type     = "application"

    web_lb_security_group = {
        name    = "${local.resource_loc}-SG-WEB-LB-3TIER"
        ingress = [
            {
                from_port        = 443
                to_port          = 443
                protocol         = "tcp"
                cidr_blocks      = ["10.0.0.0/16"]
            },
            {
                from_port        = 80
                to_port          = 80
                protocol         = "tcp"
                cidr_blocks      = ["10.0.0.0/16"]
            },
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["10.0.0.0/16"]
            }
        ]
        egress = []
    }

    ################################################################################
    # WEB Load Balancer Listener
    ################################################################################

    web_lb_listener = [
        {
            port = "80"
            protocol = "HTTP"
            default_action = {
                type = "forward"
            }
        }
    ]

    ################################################################################
    # WEB Target Group
    ################################################################################

    web_target_group = "${local.resource_loc}-WEB-TG-3TIER"
    web_target_protocol = "HTTP"
    web_target_port     = 80

    ################################################################################
    # WAS instance spec
    ################################################################################

    was_instance_ami       = "ami-07839a994b72a37b3"
    was_instance_type      = "t3.micro"

    was_security_group = {
        name    = "${local.resource_loc}-SG-WAS-AS-3TIER"
        ingress = [
            {
                from_port        = 8080
                to_port          = 8080
                protocol         = "tcp"
                cidr_blocks      = ["10.0.0.0/16"]
            },
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
        egress = [
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
    }

    was_prev_step = true

    was_security_group_ids = ["sg-0aafd610bbd1bb9a4"]

    was_auto_scale_lc_name    = "${local.resource_loc}-WAS-AS-3TIER-LC"
    was_auto_scale_group_name = "${local.resource_loc}-WAS-AS-3TIER-GROUP"

    ################################################################################
    # WAS Launch configuration
    ################################################################################

    was_ebs_block_device = [
        {
        no_device             = 0
        device_name           = "/dev/xvdz"
        delete_on_termination = true
        encrypted             = true
        volume_type           = "gp2"
        volume_size           = "50"
        },
    ]

    was_root_block_device = [
        {
        delete_on_termination = true
        encrypted             = true
        volume_size           = "50"
        volume_type           = "gp2"
        },
    ]

    ################################################################################
    # WAS Autoscaling group
    ################################################################################

    was_min_size                  = 0
    was_max_size                  = 1
    was_desired_capacity          = 1

    ################################################################################
    # WAS Load Balancer
    ################################################################################

    was_load_balancer          = "${local.resource_loc}-WAS-LB-3TIER"
    was_load_balancer_type     = "application"

    was_lb_security_group = {
        name    = "${local.resource_loc}-SG-WAS-LB-3TIER"
        ingress = [
            {
                from_port        = 8080
                to_port          = 8080
                protocol         = "tcp"
                cidr_blocks      = ["10.0.0.0/16"]
            },
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["10.0.0.0/16"]
            }
        ]
        egress = []
    }

    ################################################################################
    # WAS Load Balancer Listener
    ################################################################################

    was_lb_listener = [
        {
            port = "8080"
            protocol = "HTTP"
            default_action = {
                type = "forward"
            }
        }
    ]

    ################################################################################
    # WAS Target Group
    ################################################################################

    was_target_group = "${local.resource_loc}-WAS-TG-3TIER"
    was_target_protocol = "HTTP"
    was_target_port     = 8080

    ################################################################################
    # MariaDB Configurations (Master Password, DB Subnet, Option Group, Parameter Group)
    ################################################################################

    #### For creating Parameter store for MySQL master user's password
    parameter_store_name    = "${local.resource_loc}-RDS-PRM-MARIADB1-MASTER"
    db_name_user            = "/${local.resource_loc}-RDS-MARIADB1/dbadmin"

    #### For creating DB subnets
    db_subnet_group_name    = "${local.resource_loc}-SNG-RDS-MARIADB1"

    ##### For creating Option group
    option_group_name       = "${local.resource_loc}-OPT-MARIADB1"

    ##### For creating Parameter group
    parameter_group_name    = "${local.resource_loc}-PRM-MARIADB1"

    #### For creating RDS monitoring role
    monitoring_role_name    = "${local.resource_loc}-ROL-RDS-MON-MARIADB1"

    ################################################################################
    # MariaDB
    ################################################################################

    #### For creating RDS DB's security group
    rds_security_group = {
        name    = "${local.resource_loc}-SG-RDS-MARIADB1"
        ingress = [
            {
                from_port        = 3306
                to_port          = 3306
                protocol         = "tcp"
                cidr_blocks      = ["0.0.0.0/0"]
            },
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
        egress = [
            {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
    }

    #### For creating RDS DB
    database_name           = "MARIADB1"
    identifier              = "${local.resource_loc}-RDS-MARIADB1"
    db_port                 = "3306"
    instance_class          = "db.t3.medium"
    kms_key_id              = "arn:aws:kms:ap-northeast-2:794410467178:key/68872c5d-4619-4c9f-a65b-2612554a7121"
    username                = "dbadmin"
}