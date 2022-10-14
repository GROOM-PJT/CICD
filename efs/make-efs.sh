# 1. EKS 클러스터의 vpc_id 값 조회
vpc_id=$(aws eks describe-cluster \
    --name groom-EKS \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)
wait
# 2. EKS 클러스터가 속한 vpc의 network cidr 조회
cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids $vpc_id \
    --query "Vpcs[].CidrBlock" \
    --output text)

# 3. EFS의 보안그룹 생성
security_group_id=$(aws ec2 create-security-group \
    --group-name efs-security \
    --description "security grouo for efs" \
    --vpc-id $vpc_id \
    --output text)
wait
# 4. 보안그룹에 인바운드 정책 추가
aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range
wait  
# 5. EFS 생성
file_system_id=$(aws efs create-file-system \
    --region ap-northeast-2 \
    --performance-mode generalPurpose \
    --tag Key=Name,Value=groom-efs \
    --query 'FileSystemId' \
    --output text)

# 6. subnet table 띄우기
aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$vpc_id" \
    --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
    --output table
echo "$security_group_id"
echo "$file_system_id"

cat ./ci-cd/efs/help_efs
