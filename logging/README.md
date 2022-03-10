# [AWS Logging module]

## 개요

AWS에서 각 계정별 로그 수집설정 자동화와 cloudtrail을 활성화합니다.
  - 각 계정별 로그 수집 설정 자동화
  - vpc Flow log, cloud trail 활성화
  - 계정별 수집 로그 -> 로그 계정으로 자동 수집

### 실행환경
  - 지정한 lifecycle에 따라 Rule을 적용하여 각 S3 Bucket별로 데이터 보관 주기를 관리합니다.
  - cloudtrail, lambda, flowlogs 에 대한 IAM 권한이 활성화 되어 있어야 합니다
  - S3 Bucket별로 접근 로그(Access Log)를 남기도록 하여 사용자 및 리소스가 Bucket에 접근하는 것을 관리합니다.
  - Bucket의 Versioning을 관리합니다.
  