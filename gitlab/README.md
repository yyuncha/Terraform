# [GITLAB module]

## 개요

Gitlab module은 CI 환경 구성을 위해 AWS 환경에 VM Instance를 생성하는 기능을 수행합니다.
  - Gitlab Instance용 VM Instance 생성
  - GitLab Instance 실행 시 적용할 template file 생성
  - Gitlab Instance용 IAM Role 생성
  - Gitlab Instance용 Load Balancer 생성
  - Gitlab Instance용 Network 구성 사용

## 사용시 고려사항

실행환경
  - shared service account등의 랜딩존 core account가 사전 생성된 전제하에 수행합니다.
  - instance 구성에 필요한 기본적인 네트워크 환경이 사전 생성된 전제하에 수행합니다.
  - GitLab instance에 사용될 도메인주소가 사전 생성된 전제하에 수행합니다.
  - IAM Role session manager 접속을 위한 권한 구성이 포함되어 있습니다.
  - GitLab pipeline 구성에 필요한 ECR,ECS,SSM 등에 대한 권한이 IAM에 포함되어 있습니다.
  - 접속 URL 에 대하여 WhiteList에 대해서 80 포트와 443 포트에 대한 접근이 구성됩니다.
  - VM 구성 후 설치 script가 ubuntu 20.04 기준으로 구성됩니다.
  - 접속도메인에 대해서 ns record 등록작업이 필요합니다.
  - VM 구성 후에 gitlab runner 등록을 위한 credential token 값 확인후 docker 등록이 수행됩니다.
    ```shell
    docker run -d --name gitlab-runner --net=host --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock:rw \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /root/.docker/:/root/.docker/ \
    -v /usr/bin/docker-credential-ecr-login:/usr/bin/docker-credential-ecr-login \
    gitlab/gitlab-runner:latest
    ```

  - pipeline 실행시 ECR 이미지를 가져오기 위해 Docker ECR Credential Helper 설치 후 config.json 설정됨
    ```shell
    {
    "credHelpers": {
      "${aws_account_id}.dkr.ecr.${region}.amazonaws.com": "ecr-login"
      }
    }
    ```

  - docker 등록 수행 후 docker 에 등록된 docker에 접속해서 gitlab runner 등록명령어를 입력합니다.
    ```shell
      docker exec -it gitlab-runner /bin/bash
      gitlab-ci-multi-runner register -n --url http://localhost/ \
      --registration-token {PUT GITLAB RUNNER TOKEN HERE} \
      --executor docker \
      --description "gitlab-runner01" \
      --docker-pull-policy "if-not-present" \
      --clone-url "http://localhost" \
      --docker-image "docker:latest" \
      --docker-network-mode "host" \
      --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
      --docker-volumes /cache \
      --docker-volumes /usr/bin/docker-credential-ecr-login:/usr/bin/docker-credential-ecr-login \
      --docker-volumes /root/.docker/:/root/.docker/
    ```
  - Pipeline 수행 시 사용될 AWS Credential 정보는 gitlab ci-cd variables에 등록이 필요합니다.

## 사용법(예시)
```hcl
locals {
  resource_loc  = "TEST-AN2-DEV"
  instance_name = "GITLAB"
  gitlab_domain = "shinhans.tk"
}

module "gitlab" {
  source            = "../"
  aws_region        = "ap-northeast-2"
  shared_account_id = "151564769076" # shared service account ID

  ec2_instance_ami                = "ubuntu20"
  ec2_instance_type               = "t3.large"
  ec2_ebs_optimized               = true
  ec2_disable_api_termination     = false
  ec2_block_volume_size           = "20"
  ec2_block_volume_type           = "gp3"
  ec2_block_encrypted             = true
  ec2_block_delete_on_termination = false

  gitlab_domain_name    = local.gitlab_domain
  gitlab_host_name      = "gitlab.${local.gitlab_domain}"
  gitlab_url            = "http://gitlab.${local.gitlab_domain}"
  gitlab_version        = "13.10.2-ce.0"
  gitlab_runner_version = "13.10.0"
  whitelist_ips = [
    "59.18.215.72/32",  #Shinhan local
  ]
  ec2_instance_name       = "${local.resource_loc}-EC2-${local.instance_name}"
  ec2_instance_block_name = "${local.resource_loc}-EC2-${local.instance_name}-BLOCK"
  ec2_instance_eip_name   = "${local.resource_loc}-EC2-${local.instance_name}-EIP"
  iam_name                = "${local.resource_loc}-IAM-${local.instance_name}"
  iam_profile_name        = "${local.resource_loc}-IAM-${local.instance_name}-PROFILE"
  iam_policy_name         = "${local.resource_loc}-IAM-${local.instance_name}-POLICY"
  iam_assume_policy_name  = "${local.resource_loc}-IAM-${local.instance_name}-ASSUME-POLICY"
  lb_name                 = "${local.resource_loc}-LB-${local.instance_name}"
  lb_target_group_name    = "${local.resource_loc}-LB-${local.instance_name}-TG-TCP80"
  security_group_external = "${local.resource_loc}-SG-${local.instance_name}-ALB"
  security_group_internal = "${local.resource_loc}-SG-${local.instance_name}-WEB"

  vpc_id     = "vpc-015658d8729560ca0"
  subnet_ids = ["subnet-0e28f79f6d1254505", "subnet-073d08d60e0f2eed1"]

  # For tags
  tags = {
    Stage      = "DEV"
    Org        = "Cloud team"
    Service    = "PILOT-AP"
    Owner      = "Shinhan DS"
    Project    = "PILOT"
    No_managed = "TRUE"
    History    = "initial"
  }
}
```

## Requirements

| Name                                                                      | Version    |
| ------------------------------------------------------------------------- | ---------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 3.15    |

## Providers

| Name                                              | Version |
| ------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15 |


## 참조 Modules

| 구분 | 모듈 이름 | 기능 |
| ---- | --------- | ---- |
| None |           |      |
## 생성 reource

| Name                                                            | Type     |
| --------------------------------------------------------------- | -------- |
| aws_eip.gitlab_nat_eip_public                                   | resource |
| aws_iam_instance_profile.iam_role_gitlab_profile                | resource |
| aws_iam_role.iam_role_gitlab                                    | resource |
| aws_iam_role_policy.gitlab_iam_role_policy                      | resource |
| aws_iam_role_policy_attachment.gitlab_ecr_full_access           | resource |
| aws_iam_role_policy_attachment.gitlab_ecs_full_access           | resource |
| aws_iam_role_policy_attachment.gitlab_s3_readonly_access        | resource |
| aws_iam_role_policy_attachment.gitlab_ssm_full_access           | resource |
| aws_instance.gitlab_ec2_instance                                | resource |
| block_device                                                    | resource |
| aws_lb.gitlab_lb                                                | resource |
| aws_lb_listener.gitlab_lb_listener_443                          | resource |
| aws_lb_listener.gitlab_lb_listener_80                           | resource |
| aws_lb_target_group.gitlab_lb_target_group                      | resource |
| aws_lb_target_group_attachment.gitlab_lb_target_group-attchment | resource |
| aws_security_group.gitlab_sg_external                           | resource |
| aws_security_group.gitlab_sg_internal                           | resource |
| aws_acm_certificate.gitlab_acm_cert                             | resource |
| aws_acm_certificate_validation.gitlab_acm_cert_valid            | resource |
| aws_route53_record.gitlab_route_record                          | resource |
| aws_route53_zone.gitlab_route_zone                              | resource |

## Inputs

| Name                            | Description                                  | Type   | Default        | Required |
| ------------------------------- | -------------------------------------------- | ------ | -------------- | :------: |
| aws_region                      | aws region 이름                              | string | ap-northeast-2 |   yes    |
| shared_account_id               | ci tool이 설치 되어 있는 shared account ID   | string |                |   yes    |
| ec2_instance_ami                | gitlab instance에 사용될 instance 이미지     | string | ubuntu20       |   yes    |
| ec2_instance_type               | gitlab instance에 사용되는 instance 성능타입 | string | t3.large       |   yes    |
| ec2_ebs_optimized               | gitlab instance ebs optimized 여부           | string | true           |   yes    |
| ec2_disable_api_termination     | gitlab instance disabled시 종료여부          | string | false          |   yes    |
| ec2_block_volume_size           | gitlab instance block 사이즈                 | string | 20             |   yes    |
| ec2_block_volume_type           | gitlab instance block 타입                   | string | gp3            |   yes    |
| ec2_block_encrypted             | gitlab instance block 암호화여부             | string | true           |   yes    |
| ec2_block_delete_on_termination | gitlab instance block 종료시 삭제여부        | string | false          |   yes    |
| gitlab_domain_name              | GitLab이 사용할 도메인                       | string |                |   yes    |
| gitlab_host_name                | GitLab이 사용할 호스트네임                   | string |                |   yes    |
| gitlab_url                      | gitlab vm이 돌아갈 gitlab url                | string |                |   yes    |
| gitlab_version                  | gitlab vm에 설치될 gitlab version            | string | 13.10.2-ce.0   |   yes    |
| gitlab_runner_version           | gitlab vm이 속할 gitlab runner version 명    | string | 13.10.0        |   yes    |
| whitelist_ips                   | GitLab 서버에 접속가능한 IP List             | list   |                |   yes    |
| ec2_instance_name               | instance Name Tag                            | string |                |    no    |
| ec2_instance_block_name         | ec2_instance_block Name Tag                  | string |                |    no    |
| ec2_instance_eip_name           | ec2_instance_eip Name Tag                    | string |                |    no    |
| iam_role_gitlab_name            | iam_role_gitlab Name Tag                     | string |                |    no    |
| iam_role_gitlab_profile_name    | iam_role_gitlab_profile Name Tag             | string |                |    no    |
| iam_role_gitlab_policy_name     | iam_role_gitlab_policy Name Tag              | string |                |    no    |
| lb_name                         | lb Name Tag                                  | string |                |    no    |
| lb_target_group_name            | lb_target_group Name Tag                     | string |                |    no    |
| security_group_external         | gitlab vm이 속할 security_group_external 명  | string |                |    no    |
| security_group_internal         | gitlab vm이 속할 security_group_internal 명  | string |                |    no    |
| vpc_id                          | gitlab vm이 속할 vpc id                      | string |                |   yes    |
| subnet_ids                      | gitlab vm이 속할 public_subnet id            | string |                |   yes    |
## Outputs

| Name                    | Description                     |
| :---------------------- | :------------------------------ |
| gitlab_instance         | gitlab Instance ID 정보         |
| lb_security_group       | application 보안 그룹 ID 정보   |
| iam_role_gitlab_profile | iam_role_gitlab_profile ID 정보 |
| web_security_group      | web 보안그룹 ID 정보            |
