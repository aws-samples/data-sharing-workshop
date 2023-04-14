if [[ -z ${TF_VAR_remote_acct_1+x} ]];then
echo "TF_VAR_remote_acct_1 not set"
exit 
fi
if [[ -z ${TF_VAR_remote_acct_2+x} ]];then
echo "TF_VAR_remote_acct_2 not set"
exit 
fi
#
# Accept resource shares

for i in `aws ram get-resource-share-invitations --query resourceShareInvitations[].resourceShareInvitationArn --output text`; do
echo "Accepting RAM share $i"
aws ram accept-resource-share-invitation --resource-share-invitation-arn $i
done  

cd ~/environment/xgov/xacct
terraform init
terraform apply -auto-approve
echo "check RAM shares"
~/environment/xgov/.aws-staff/check-05-ram-shares.sh
#
