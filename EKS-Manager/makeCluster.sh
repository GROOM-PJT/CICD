# 1. cluster 생성
eksctl create cluster \
    --name groom-EKS\
    --region ap-northeast-2 \
    --with-oidc \
    --ssh-access \
    --ssh-public-key groom-EKS \
    --nodes 3 \
    --node-type t3.medium \
    --node-volume-size=20 \
    --managed

wait
# 2. kubectl 자동완성 설정 
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
