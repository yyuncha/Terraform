# [cloudfront module]

## 개요

cloudfront module은 AWS cloudfront를 생성하고 예제용 S3 bucket을 생성합니다.
  - cloudfront distribution을 생성.
  - 예시용 S3 bucket을 생성합니다. (default html 파일을 게시 합니다.)
  - cloudfront를 통해 사용될 alias를 public hosted zone에 연결합니다.

## 사용시 고려사항

### 실행환경
  - cloudfront distribuction의 origin 값으로 S3를 연결하기 위해서는 s3의 bucket_doamin_name값이 필요합니다.
  - public DNS(예 : Route53 public hosted zone)가 사전에 설정되어 있어야 합니다.
  - Cloudfront 생성이 완료되면 Cloudfront의 domain_name과 설정된 alias값을 이용해 record를 생성합니다.
