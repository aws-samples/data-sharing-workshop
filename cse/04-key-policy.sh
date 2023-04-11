export KeyID=$(cd ~/environment/xgov/tfinit && terraform output | grep keyid | cut -f2 -d'=' | tr -d ' "')
#
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION=$(aws configure get region)
cat > key-policy.json <<EOF
{
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
        {
            "Sid" : "Enable IAM User Permissions",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : "arn:aws:iam::${ACCOUNT_ID}:root"
            },
            "Action" : "kms:",
            "Resource" : "*"
        },
        {
            "Sid" : "Allow Use of Key",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : "arn:aws:iam::${ACCOUNT_ID}:role/test-user"
            },
            "Action" : [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:ListKeys"
            ],
            "Resource" : "*"
        }
    ]
}
EOF
aws kms put-key-policy \
    --policy-name default \
    --key-id $KeyID \
    --policy file://key-policy.json
