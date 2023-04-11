if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
cd ~/environment/xgov/perms
terraform init
terraform apply -auto-approve

