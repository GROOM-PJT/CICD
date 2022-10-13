sudo apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
wait
chmod +x ./kubectl
wait
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin 
wait
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
wait
chmod 700 get_helm.sh
wait
./get_helm.sh

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

echo "aws version"
aws --version
echo "eksctl version"
eksctl version
echo "helm version"
./get_helm.sh
echo " kubectl version "
kubectl version --short --client


echo "$ makeCluster after setting 'aws configure'"