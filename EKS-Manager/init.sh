# 1. aws-cli 설치
sudo apt-get install -y unzip
wait
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
wait
unzip awscliv2.zip
wait
sudo ./aws/install

# 2. eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
wait
sudo mv /tmp/eksctl /usr/local/bin

# 3. kubectl 설치 
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
wait
chmod +x ./kubectl
wait
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin 
wait
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc


# 4. helm3 설치
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
wait
sudo chmod 700 get_helm.sh
wait
./get_helm.sh


# 5. amazon-efs-utils 설치
sudo apt-get update
wait
git clone https://github.com/aws/efs-utils
wait
sudo apt-get -y install binutils
wait
cd efs-utils
wait
./build-deb.sh
wait
sudo apt-get -y install ./build/amazon-efs-utils*deb
wait


# 6. aws-efs-csi-driver 설치 (helm 사용)
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/add-ons-images.html
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
wait
helm repo update
wait
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa


echo "aws version"
aws --version
echo "eksctl version"
eksctl version
echo "helm version"
helm version
echo " kubectl version "
kubectl version --short --client

# 7. 다음 동작은 aws configure 설정 후 수행 가능
echo "$ chmod +x ./kubectl"
echo "$ makeCluster after setting 'aws configure'"
