# 패키지 업데이트
sudo apt-get update -y
wait
# 기존에 있던 도커 삭제
sudo apt-get remove docker docker-engine docker.io -y
wait
# 도커 설치
sudo apt-get install docker.io -y
wait

sudo apt install openjdk-11-jdk
wait

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
wait

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
wait

sudo apt-get update
wait

sudo apt-get install jenkins
wait

sudo systemctl status jenkins

echo """
# /var/run/docker.sock 파일의 권한을 666으로 변경하여 그룹 내 다른 사용자도 접근 가능하게 변경
sudo chmod 666 /var/run/docker.sock

# ubuntu 유저를 docker 그룹에 추가
sudo usermod -a -G docker ubuntu
"""
