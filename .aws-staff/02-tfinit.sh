source ~/.bash_profile
if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
echo "tf init"
cd ~/environment/xgov/tfinit
terraform init
terraform apply -auto-approve
echo "copy data...."
cd ~/environment/xgov/data
aws s3 cp sales.csv s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/sales/sales.csv
aws s3 cp products.csv s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/products/products.csv
aws s3 cp customers${TF_VAR_team_number}.csv s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.csv
~/environment/xgov/.aws-staff/check-01-init.sh