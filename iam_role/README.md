# [iam_role_policy module]


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

iam_role_policy module은 IAM Policy와 IAM Role을 생성합니다. 생성된 IAM Role에 IAM Policy를 연결합니다.
  - IAM Role을 생성합니다.
  - IAM Policy를 생성합니다.
  - IAM Policy에 정책을 json파일 형태로 부여 합니다.
  - 생성된 IAM Role에 IAM Policy를 연결합니다.

