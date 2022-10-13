# CICD
jenkins + argoCD를 EKS에 올리기 위한 yaml 파일


### EKS 관련 기본 셋팅
```
$ sh ci-cd/EKS-Manager/init.sh
$ chmod +x ./kubectl
$ aws configure
    - input (IAM USER DATA with AdministratorAccess)
$ sh ci-cd/EKS-Manager/makeCluster.sh
```

### EFS 및 관려 설정 생성 & Subnet Mount
```
$ sh ci-cd/efs/make-efs.sh

subnet 2개 이상 연결 추천

$ aws efs create-mount-target \
    --file-system-id fs-0000000 \
    --subnet-id subnet-000000000 \
    --security-groups sg-0000000000
    
modifiy pv.yaml EFS id 수정
``` 

### 이후 pv,pvc, 등 설정 

```
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
