# [vpc_setup module]


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15 |

## 개요

WS VPC 자원을 생성하는 기능을 수행
  - AWS VPC를 구성하며 기본 VPC 및 Subnet의 inn, lb, ap, db subnet을 생성합니다.
  - VPC에 있는 각 서브넷의 내/외부 트래픽을 제어하기 위한 Network ACL을 설정합니다.

  - 다른 AWS 서비스를 사용할 때 AWS 내무망을 사용하기 위해 VPC Endpoint를 생성합니다. 기본적으로 s3, lambda, ssm에 대한 VPC Endpoint를 구성합니다.
  - Terraform이 수행될 때, 생성되는 자원들이 기본적으로 aws vpc-id를 참조하므로 




