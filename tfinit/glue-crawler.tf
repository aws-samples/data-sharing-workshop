
resource "aws_glue_crawler" "xgov" {
  depends_on = [null_resource.sleep,aws_kms_key.xgovkey,null_resource.copy]

  database_name = "xgov"
  name          = "xgov"
  # this role comes from CloudFormation
  role          = aws_iam_role.LF-GlueServiceRole.arn

  s3_target {
    path = "s3://${aws_s3_bucket.xgov-data.bucket}/raw-data"
  }
}

# nope

#  role          = data.aws_iam_role.lf-admin.arn#











