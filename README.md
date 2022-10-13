# CICD
jenkins + argoCD를 EKS에 올리기 위한 yaml 파일


```
sh ci-cd/EKS-Manager/init.sh
chmod +x ./kubectl
aws configure
sh ci-cd/EKS-Manager/makeCluster.sh
sh ci-cd/efs/make-efs.sh
```

### mount subnet to EFS
```
modifiy - subnet 2개 이상

aws efs create-mount-target \
    --file-system-id fs-0000000 \
    --subnet-id subnet-000000000 \
    --security-groups sg-0000000000
``` 

### 이후 pv,pvc, 등 설정 

```
kubectl apply -f ci-cd/efs/pv.yaml
kubectl apply -f ci-cd/efs/pvc.yaml
kubectl apply -f ci-cd/efs/storage-class.yaml

kubectl apply -f ci-cd/jenkins/jenkins_deployment.yaml
kubectl apply -f ci-cd/jenkins/jenkins_service.yaml
```
