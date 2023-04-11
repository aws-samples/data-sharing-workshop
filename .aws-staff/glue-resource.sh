if [[ -z ${TF_VAR_remote_acct_1+x} ]];then
echo "TF_VAR_remote_acct_1 not set"
exit 
fi
if [[ -z ${TF_VAR_remote_acct_2+x} ]];then
echo "TF_VAR_remote_acct_2 not set"
exit 
fi
accid=$(aws sts get-caller-identity --query Account --output text)
cat <<EOF >glue-Resource.json
{
    "Effect": "Allow",
    "Action": [
        "glue:*"
    ],
    "Principal": {
        "AWS": [
            "${TF_VAR_remote_acct_1}",
            "${TF_VAR_remote_acct_2}"
        ]
    },
    "Resource": [
        "arn:aws:glue:${AWS_REGION}:${accid}:table/*",
        "arn:aws:glue:${AWS_REGION}:${accid}:database/*",
        "arn:aws:glue:${AWS_REGION}:${accid}:catalog"
    ],
    "Condition": {
        "Bool": {
            "glue:EvaluatedByLakeFormationTags": true
        }
    }
}
EOF
#aws glue put-resource-policy --policy-in-json file://glue-Resource.json