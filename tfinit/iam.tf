# these roles comes from CloudFormatio

data "aws_iam_role" "WSParticipantRole" {
    name = "WSParticipantRole"
}

data "aws_iam_role" "lf-admin" {
    name = "lf-admin"
}




# attach policy allowing acccess to buckets to the Glue role
resource "aws_iam_role_policy" "my_s3_policy2" {
  name   = "my_s3_policy2"
  role   = aws_iam_role.LF-GlueServiceRole.id
  policy = data.aws_iam_policy_document.xgov-s3.json
}

data "aws_iam_policy_document" "xgov-s3" {
  statement {
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.xgov-data.id}",
      "arn:aws:s3:::${aws_s3_bucket.xgov-data.id}/*"
    ]
  }
}