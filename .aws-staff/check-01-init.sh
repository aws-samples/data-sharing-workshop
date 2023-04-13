source ~/.bash_profile
echo 'Should return "3"'
aws s3 ls s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/ | wc -l
echo "check TF_VAR_team_number is correct"
echo $TF_VAR_team_number
echo "check TF_VAR_region is eu-west-1"
echo $TF_VAR_region
