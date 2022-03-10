#!/bin/bash
sudo su -
sudo apt update
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# root / root
#########################################################################
####################### Gitlab 설치전 필수 패키지 #######################
########################################################################
sudo apt install -y curl openssh-server ca-certificates
#sudo apt install postfix ####GitLab EMail 기능

#########################################################################
######################## Gitlab 설치 13.10.2 버전 #######################
#########################################################################
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo EXTERNAL_URL=${GITLAB_URL} apt install gitlab-ce=${GITLAB_VERSION}
## http로 접속을 시도시키고 실제 접속은 https로 라우팅


########################################################################
######################## Gitlab External IP 설정 #######################
########################################################################
# sudo vi /etc/gitlab/gitlab.rb
# ls -al build/libs | grep jar
# sed -i "s/http://gitlab.example.com/3.36.255.248/g" /etc/gitlab/gitlab.rb

###################################################################
######################### Gitlab 설정 적용 ########################
###################################################################
sudo gitlab-ctl reconfigure

####################################################################
################### Gitlab Runner 설치위한 docker ##################
####################################################################
sudo apt install -y docker.io #19.03.6
sudo service docker start
sudo usermod -aG docker root
sudo service docker restart

####################################################################
########################  Gitlab Runner 설치 #######################
####################################################################
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install -y gitlab-runner=${GITLAB_RUNNER_VERSION}

####################################################################
########################  Gitlab Runner 설정 #######################
####################################################################
#sudo gitlab-ci-multi-runner register -n --url http://localhost --registration-token tbCc7sK2zKL8AUQyJ3Yg --executor docker --description "docker runner:shared-socket" --docker-image "docker:latest" --docker-volumes /var/run/docker.sock:/var/run/docker.sock
#sudo vi /etc/gitlab-runner/config.toml
sudo gitlab-ci-multi-runner restart

####################################################################
####################  Session-Manager 설치/실행 ####################
####################################################################
sudo snap install amazon-ssm-agent --classic  # 설치
# sudo snap list amazon-ssm-agent # 조회
sudo snap start amazon-ssm-agent # 실행
# sudo snap services amazon-ssm-agent #상태확인

####################################################################
####################  Sonarqube 컨테이너로 기동 ####################
####################################################################
#docker run -d --name sonarqube -p 9000:9000 sonarqube:8.8-community


####################################################################
######################  Nexus 컨테이너로 기동 ######################
####################################################################
#docker run -d --name nexus -p 8081:8081 nexus


####################################################################
######################  Go 설치               ######################
####################################################################

sudo apt install -y awscli
# # Docker ECR Credential Helper 설치
sudo apt install amazon-ecr-credential-helper

# snap install aws-cli --classic;
# # go 설치
# sudo snap install go --classic;
# # Docker ECR Credential Helper 설치하기 위해 환경변수 설정
# export GOPATH=$HOME/go;
# export PATH=$PATH:$GOPATH/bin;
# go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login;

####################################################################
######################  Docker : GitLab Runner 실행 ################
####################################################################
docker run -d --name gitlab-runner --net=host --restart always \
-v /var/run/docker.sock:/var/run/docker.sock:rw \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /root/.docker/:/root/.docker/ \
-v /usr/bin/docker-credential-ecr-login:/usr/bin/docker-credential-ecr-login \
gitlab/gitlab-runner:latest

###################################################################
######################  Docker : GitLab Runner 실행 ################
####################################################################
sudo echo {$'\n\t'\"credHelpers\": {$'\n\t\t'\"${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com\": \"ecr-login\"$'\n\t'}$'\n'}> ~/.docker/config.json