resource "aws_lakeformation_resource" "xgov" {
  arn = aws_s3_bucket.xgov-data.arn
  role_arn=aws_iam_role.LF-GlueServiceRole.arn
  # default = arn:aws:iam::392790326549:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess
}


