source ~/.bash_profile
sc=$(aws s3 ls s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/ | wc -l)
if [[ $sc -eq 3 ]];then
echo "PASSED: found 3 data files in S3"
else
echo "ERROR: did not find 3 data files in S3"
fi
if [[ -z ${TF_VAR_team_number+x} ]]; then
    echo "ERROR: TF_VAR_team_number is not set"
else
    echo "PASSED: TF_VAR_team_number is set $TF_VAR_team_number"
fi
if [[ -z ${TF_VAR_region+x} ]]; then
    echo "ERROR: TF_VAR_region is not set"
else
    echo "PASSED: TF_VAR_region is set $TF_VAR_region"
fi