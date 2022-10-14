# CICD
jenkins + argoCD를 EKS에 올리기 위한 yaml 파일


### EKS 관련 기본 셋팅
```
$ sh ci-cd/EKS-Manager/init.sh
$ chmod +x ./kubectl
$ mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin 

# input (IAM USER DATA with AdministratorAccess)
$ aws configure 

$ sh ci-cd/EKS-Manager/makeCluster.sh
```

### EFS 및 관려 설정 생성 & Subnet Mount
```
$ sh ci-cd/efs/make-efs.sh
$ source <(kubectl completion bash)
$ echo "source <(kubectl completion bash)" >> ~/.bashrc

# subnet 2개 이상 연결 추천

$ aws efs create-mount-target \
    --file-system-id fs-0000000 \
    --subnet-id subnet-000000000 \
    --security-groups sg-0000000000
    
# modifiy pv.yaml EFS id 수정
$ vi ci-cd/efs/pv.yaml
```

### aws-efs-csi-driver 설치 (helm 사용)

```
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/add-ons-images.html
$ helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
$ helm repo update
$ helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa

``` 

### 이후 jenkins 설치

```
$ kubectl create namespace jenkins
$ kubectl apply -f ci-cd/efs/pv.yaml
$ kubectl apply -f ci-cd/efs/pvc.yaml
$ kubectl apply -f ci-cd/efs/storage-class.yaml

$ kubectl apply -f ci-cd/jenkins/jenkins_deployment.yaml
$ kubectl apply -f ci-cd/jenkins/jenkins_service.yaml
```


### 삭제시 
```
$ eksctl delete cluster --name groom-EKS


AWS Console

1. EFS 삭제
2. VPC 삭제
```
