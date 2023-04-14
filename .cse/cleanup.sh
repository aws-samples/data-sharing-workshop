aws eks delete-fargate-profile --cluster-name eks-emr --fargate-profile-name fp-default
fgs=$(aws eks describe-fargate-profile --cluster-name eks-emr --fargate-profile-name fp-default --query fargateProfile.status --output text)
while [[ $fgs == "DELETING" ]]; do
    echo "waiting for fargate profile deletion"
    sleep 10
    fgs=$(aws eks describe-fargate-profile --cluster-name eks-emr --fargate-profile-name fp-default --query fargateProfile.status --output text 2> /dev/null)
done
aws eks delete-cluster --name eks-emr
cls=$(aws eks describe-cluster --name eks-emr --query cluster.status --output text)
while [[ $cls == "DELETING" ]]; do
    echo "waiting for cluster deletion"
    sleep 10
    cls=$(aws eks describe-cluster --name eks-emr --query cluster.status --output text 2> /dev/null)
done
aws cloudformation delete-stack --stack-name eksctl-eks-emr-cluster
ss=$(aws cloudformation describe-stacks --stack-name eksctl-eks-emr-cluster --query Stacks[].StackStatus --output text)
echo $ss
while [[ $ss == "DELETE_IN_PROGRESS" ]]; do
    echo "waiting for cloudformation deletion"
    sleep 10
    ss=$( aws cloudformation describe-stacks --stack-name eksctl-eks-emr-cluster --query Stacks[].StackStatus --output text 2> /dev/null)
done
