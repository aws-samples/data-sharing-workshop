if [[ -z ${TF_VAR_team_number+x} ]]; then
    echo "TF_VAR_team_number not set"
else
    export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    export AWS_REGION=$(aws configure get region)
    export S3_BUCKET=s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}
    echo "delete customers${TF_VAR_team_number}.csv"
    aws s3 rm ${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.csv
fi
