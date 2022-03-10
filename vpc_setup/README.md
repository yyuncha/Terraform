# [vpc_setup module]

## 개요

vpc setup module은 AWS 랜딩존에서 필요에 따라 Service Account가 추가된 경우 AWS VPC 자원을 생성하는 기능을 수행합니다.
  - AWS VPC를 구성하며 기본 VPC 및 Service Account에서 사용하는 inn, lb, ap, db subnet을 생성합니다.
  - VPC에 있는 각 서브넷의 내/외부 트래픽을 제어하기 위한 Network ACL을 설정합니다.
  - Service Account의 Route Tables 구성은 기본적으로 TGW를 사용하도록 설정합니다.
  - 다른 AWS 서비스를 사용할 때 AWS 내무망을 사용하기 위해 VPC Endpoint를 생성합니다. 기본적으로 s3, lambda, ssm에 대한 VPC Endpoint를 구성합니다.
  - Terraform이 수행될 때, 생성되는 자원들이 기본적으로 aws vpc-id를 참조하므로 별도 서브 모듈로 분리하지 않고 같은 디렉토리에서 tf파일만 분리 구성하여 수행합니다 

## 사용시 고려사항

실행환경
  - 랜딩존 환경에서 Service Account 생성시에 사용합니다. 기존 PRD, STG, DEV외에 플랫폼 성격이나 빅데이터, AI와 같이 별도 서비스 Account로 분리 구성이 필요한 경우에 수행합니다.

고려사항
  - Service Account는 랜딩존 환경에서 기존 Network Account에서 생성된 Transit Gateway를 사용하여 Route Tables룰 구성합니다.


## 사용법(예시)
```hcl
module "vpc_setup" {
  source          = "../../../modules/vpc_setup"

  #VPC 구성을 위한 값 setting  
  vpc = {
    name = "SHCW-AN2-PRD-VPC"
    cidr_block = "100.112.12.0/22"
    secondary_cidr_block = "100.112.20.0/22"
  }
  
  #subnet 구성을 위한 값 setting  
  #[availability_zone, cidr_block, tag_name]
  subnet_inn_1 = ["ap-northeast-2a", "100.112.12.0/24", "SHCW-AN2-PRD-SBN-INN-1"]
  subnet_inn_2 = ["ap-northeast-2c", "100.112.20.0/24", "SHCW-AN2-PRD-SBN-INN-2"]
  subnet_lb_1 = ["ap-northeast-2a", "100.112.13.0/24", "SHCW-AN2-PRD-SBN-LB-1"]
  subnet_lb_2 = ["ap-northeast-2c", "100.112.21.0/24", "SHCW-AN2-PRD-SBN-LB-2"]
  subnet_ap_1 = ["ap-northeast-2a", "100.112.14.0/24", "SHCW-AN2-PRD-SBN-AP-1"]
  subnet_ap_2 = ["ap-northeast-2c", "100.112.22.0/24", "SHCW-AN2-PRD-SBN-AP-2"]
  subnet_db_1 = ["ap-northeast-2a", "100.112.15.0/24", "SHCW-AN2-PRD-SBN-DB-1"]
  subnet_db_2 = ["ap-northeast-2c", "100.112.23.0/24", "SHCW-AN2-PRD-SBN-DB-2"]

  #Network ACL 구성을 위한 값 setting
  network_acl_inn = {
    name = "SHCW-AN2-PRD-NACL-INN"
    #[rule_no, protocol, from_port, to_port, cidr_block, action]
    ingresses = [
        [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
    ]
    egresses = [
        [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
    ]
  }

  network_acl_lb = {
      name = "SHCW-AN2-PRD-NACL-LB"
      #[rule_no, protocol, from_port, to_port, cidr_block, action]
      ingresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
      egresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
  }

  network_acl_ap = {
      name = "SHCW-AN2-PRD-NACL-AP"
      #[rule_no, protocol, from_port, to_port, cidr_block, action]
      ingresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
      egresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
  }

  network_acl_db = {
      name = "SHCW-AN2-PRD-NACL-DB"
      #[rule_no, protocol, from_port, to_port, cidr_block, action]
      ingresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
      egresses = [
          [100, "-1", 0, 0, "0.0.0.0/0", "allow"]
      ]
  }
  
  #Route table 구성을 위한 설정
  #shared, log, service, private cidr 대역에 대한 경로 설정하며 기 생성된 TGW의 id를 setting
  route_private = {
    name = "SHCW-AN2-PRD-RT-PRI"
    propagating_vgws = []
    routes = [
        # ["100.112.67.0/24", "tgw-0567fe681341df98"], #transit_gateway_shared
        # ["100.112.70.0/24", "tgw-0567fe681341df98"], #transit_gateway_shared
        ["100.112.60.0/22", "tgw-07a9bfe681881df28"], #transit_gateway_log
        ["100.112.64.0/22", "tgw-07a9bfe681881df28"], #transit_gateway_log
        ["100.112.0.0/22", "tgw-086c93b8708637419"], #transit_gateway_service
        ["100.112.4.0/22", "tgw-086c93b8708637419"], #transit_gateway_service
        ["10.0.0.0/8", "tgw-03f52cf23d8a37a69"] #transit_gateway_private
    ]
  }

  #VPC Endpoint 구성에 대한 name setting
  attachment_service = "SHCW-AN2-SERVICE-PRD-TGW-ASSC"
  # attachment_shared = "SHCW-AN2-SHARED-PRD-TGW-ASSC"
  attachment_log = "SHCW-AN2-LOG-PRD-TGW-ASSC"
  attachment_private = "SHCW-AN2-PRIVATE-PRD-TGW-ASSC"

  #VPC Endpoint 구성에 대한 name setting
  vpc_endpoint_security_group = "SHCW-AN2-PRD-VPCE-SG"

  vpc_endpoint_s3 = "SHCW-AN2-PRD-S3-EDP"
  vpc_endpoint_lambda = "SHCW-AN2-PRD-LAMBDA-EDP"
  vpc_endpoint_ssm = "SHCW-AN2-PRD-SSM-EDP"

  #Transit Gateway Attachment구성을 위해 기 생성된 TGW의 id를 setting
  #shared_transit_gateway_id = ""
  service_transit_gateway_id = "tgw-086c93b8708637419"
  log_transit_gateway_id = "tgw-07a9bfe681881df28"
  private_transit_gateway_id = "tgw-03f52cf23d8a37a69"

}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15 |


## 참조 Modules

N/A


## 생성 reource

| Name | Type |
|------|------|
| aws_vpc.vpc | resource |
| aws_vpc_ipv4_cidr_block_association.secondary_cidr | resource |
| aws_subnet.subnet_inn_1 | resource |
| aws_subnet.subnet_inn_2 | resource |
| aws_subnet.subnet_lb_1 | resource |
| aws_subnet.subnet_lb_2 | resource |
| aws_subnet.subnet_ap_1 | resource |
| aws_subnet.subnet_ap_2 | resource |
| aws_subnet.subnet_db_1 | resource |
| aws_subnet.subnet_db_2 | resource |
| aws_network_acl.network_acl_inn | resource |
| aws_network_acl.network_acl_lb | resource |
| aws_network_acl.network_acl_ap | resource |
| aws_network_acl.network_acl_db | resource |
| aws_route_table.route_private | resource |
| aws_route_table_association.subnet_inn_1 | resource |
| aws_route_table_association.subnet_inn_2 | resource |
| aws_route_table_association.subnet_lb_1 | resource |
| aws_route_table_association.subnet_lb_2 | resource |
| aws_route_table_association.subnet_ap_1 | resource |
| aws_route_table_association.subnet_ap_2 | resource |
| aws_route_table_association.subnet_db_1 | resource |
| aws_route_table_association.subnet_db_2 | resource |
| aws_ec2_transit_gateway_vpc_attachment.attachment_service | resource |
| aws_ec2_transit_gateway_vpc_attachment.attachment_log | resource |
| aws_ec2_transit_gateway_vpc_attachment.attachment_private | resource |
| aws_security_group.vpc_endpoint_security_group | resource |
| aws_vpc_endpoint.vpc_endpoint_s3 | resource |
| aws_vpc_endpoint.vpc_endpoint_lambda | resource |
| aws_vpc_endpoint.vpc_endpoint_ssm | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc | aws vpc 정보 : name, cidr_block, secondary_cidr_block | object |  | yes |
| subnet_inn_1 | inner subnet 정보 : availability_zone, cidr_block, tag_name | list(string) |  | yes |
| subnet_lb_1 | lb subnet 정보 : availability_zone, cidr_block, tag_name | list(string) |  | yes |
| subnet_ap_1 | ap subnet 정보 : availability_zone, cidr_block, tag_name | list(string) |  | yes |
| subnet_db_1 | db subnet 정보 : availability_zone, cidr_block, tag_name | list(string) |  | yes |
| network_acl_inn| inner network acl 정보 :  name, ingress[], egress[] | object |  | yes |
| network_acl_lb| lb network acl 정보 :  name, ingress[], egress[] | object |  | yes |
| network_acl_ap| ap network acl 정보 :  name, ingress[], egress[] | object |  | yes |
| network_acl_db| db network acl 정보 :  name, ingress[], egress[] | object |  | yes |
| route_private | aws route table 정보 : name, propagating_vgws[], routes[] | object |  | yes |
| attachment_service | service transit gateway attachement 이름  | string |  | yes |
| attachment_log | log transit gateway attachement 이름  | string |  | yes |
| attachment_private | private transit gateway attachement 이름  | string |  | yes |
| service_transit_gateway_id | service transit gateway id 값  | string |  | yes |
| log_transit_gateway_id | log transit gateway id 값  | string |  | yes |
| private_transit_gateway_id | private transit gateway id 값  | string |  | yes |
| vpc_endpoint_security_group | vpc_endpoint_security_group 이름  | string |  | yes |
| vpc_endpoint_s3 | vpc_endpoint_s3 이름  | string |  | yes |
| vpc_endpoint_lambda | vpc_endpoint_lambda 이름  | string |  | yes |
| vpc_endpoint_ssm | vpc_endpoint_ssm 이름  | string |  | yes |