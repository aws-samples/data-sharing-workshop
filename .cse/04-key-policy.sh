export KeyID=$(cd ~/environment/xgov/tfinit && terraform output | grep keyid | cut -f2 -d'=' | tr -d ' "')
#
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION=$(aws configure get region)
cat >key-policy.json <<EOF
{
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
        {
            "Sid" : "Enable IAM User Permissions",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : [
                    "arn:aws:iam::${ACCOUNT_ID}:root",
                    "arn:aws:sts::${ACCOUNT_ID}:assumed-role/lf-admin/Participant",
                    "arn:aws:iam::${ACCOUNT_ID}:role/lf-admin",
                    ]
            },
            "Action" : "kms:*",
            "Resource" : "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "*"
                ]
            },
            "Action": [
                        "kms:Encrypt",
                        "kms:Decrypt",
                        "kms:ReEncrypt*",
                        "kms:GenerateDataKey*",
                        "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "ArnLike": {
                    "aws:PrincipalArn": [
                        "arn:aws:sts::${ACCOUNT_ID}:assumed-role/lf-admin/AWSLF-00-AT-xxxxxxxxxxxx-*",
                        "arn:aws:iam::${ACCOUNT_ID}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess",
                        "arn:aws:iam::${ACCOUNT_ID}:role/EMRContainers-JobExecutionRole-at",
                        "arn:aws:iam::${ACCOUNT_ID}:role/lf-admin",
                        "arn:aws:sts::${ACCOUNT_ID}:assumed-role/lf-admin/Participant"
                    ]
                }
            }
        }
    ]
}
EOF
aws kms put-key-policy \
    --policy-name default \
    --key-id $KeyID \
    --policy file://key-policy.json 
