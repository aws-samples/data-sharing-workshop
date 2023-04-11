resource "aws_kms_key" "xgovkey" {
  description = "xgov KMS key"
  enable_key_rotation= true
}


resource "aws_kms_key_policy" "xgovkey" {
  key_id = aws_kms_key.xgovkey.id
  policy = data.aws_iam_policy_document.xgovkey.json
}


data "aws_iam_policy_document" "xgovkey" {
  statement {
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
    principal = [ "*", ]
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = [
        format("arn:aws:sts::%s:assumed-role/lf-admin/AWSLF-00-AT-xxxxxxxxxxxx-*",data.aws_caller_identity.current.account_id),
        format("arn:aws:iam::%s:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess",data.aws_caller_identity.current.account_id),
        format("arn:aws:iam::%s:role/EMRContainers-JobExecutionRole-at",data.aws_caller_identity.current.account_id),
        format("arn:aws:iam::%s:role/lf-admin",data.aws_caller_identity.current.account_id),
        format("arn:aws:sts::%s:assumed-role/lf-admin/Participant",data.aws_caller_identity.current.account_id),
      ]
    }
  }


}


output "keyid" {
  value = aws_kms_key.xgovkey.key_id
}


