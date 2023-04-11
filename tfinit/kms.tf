resource "aws_kms_key" "xgovkey" {
  description = "xgov KMS key"
  enable_key_rotation= true
}


resource "aws_kms_key_policy" "xgovkey" {
  key_id = aws_kms_key.xgovkey.id
  policy = jsonencode({
    Id = "xgovkey"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
        Condition: {
                ArnLike: {
                  aws:PrincipalArn: [
                        format("arn:aws:sts::%s:assumed-role/lf-admin/AWSLF-00-AT-xxxxxxxxxxxx-*",data.aws_caller_identity.current.account_id),
                        format("arn:aws:iam::%s:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess",data.aws_caller_identity.current.account_id),
                        format("arn:aws:iam::%s:role/EMRContainers-JobExecutionRole-at",data.aws_caller_identity.current.account_id),
                        format("arn:aws:iam::%s:role/lf-admin",data.aws_caller_identity.current.account_id),
                        format("arn:aws:sts::%s:assumed-role/lf-admin/Participant",data.aws_caller_identity.current.account_id)
                    ]
                }
        }

      },
    ]
    Version = "2012-10-17"
  })
}


output "keyid" {
  value = aws_kms_key.xgovkey.key_id
}