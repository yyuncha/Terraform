# [RDS_MARIADB moudule]

## RDS_MARIADB 개요

rds_mariadb module은 AWS RDS MARIADB DB를 생성합니다. 

* Multi-Az (DB 이중화) 구성 (Active-Standby 구성임)
* RDS-MARIADB DB용 Security Group 생성
* RDS-MARIADB DB용 Option group 및 parameter group 생성
* RDS-MARIADB DB용 Subnet group 생성
* RDS-MARIADB DB용 Enhanced monitoring을 위한 Role 생성
* RDS-MARIADB DB Master 계정용 Parameter store 생성 (마스터 계정 패스워드 저장, 임의 패스워드 생성)
