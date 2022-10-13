eksctl create cluster \
    --name groom-eks\
    --region ap-northeast-2 \
    --with-oidc \
    --ssh-access \
    --ssh-public-key groom-EKS \
    --nodes 3 \
    --node-type t3.medium \
    --node-volume-size=20 \
    --managed

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

