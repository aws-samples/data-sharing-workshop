# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role.LF-GlueServiceRole:
resource "aws_iam_role" "LF-GlueServiceRole" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "firehose.amazonaws.com",
              "glue.amazonaws.com",
              "lakeformation.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
  ]
  max_session_duration = 3600
  name                 = "LF-GlueServiceRole"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

}


# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__Glue-Demo-Access-Policy:
resource "aws_iam_role_policy" "LF-GlueServiceRole__Glue-Demo-Access-Policy" {
  name = "Glue-Demo-Access-Policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:*",
          ]
          Effect = "Allow"
          Resource = [
            format("arn:aws:s3:::lf-workshop-%s/*",data.aws_caller_identity.current.account_id),
            format("arn:aws:s3:::lf-workshop-%s",data.aws_caller_identity.current.account_id)
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}

# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__LF-DataAccess-Policy:
resource "aws_iam_role_policy" "LF-GlueServiceRole__LF-DataAccess-Policy" {
  name = "LF-DataAccess-Policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "lakeformation:GetDataAccess",
            "lakeformation:GrantPermissions",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}


# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__LF-Data-Lake-Storage-Policy:
resource "aws_iam_role_policy" "LF-GlueServiceRole__LF-Data-Lake-Storage-Policy" {
  name = "LF-Data-Lake-Storage-Policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:*",
          ]
          Effect = "Allow"
          Resource = [
            format("arn:aws:s3:::lf-data-lake-%s/*",data.aws_caller_identity.current.account_id),
            format("arn:aws:s3:::lf-data-lake-%s",data.aws_caller_identity.current.account_id)
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}

# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__LF-GoveredTable-Policy:
resource "aws_iam_role_policy" "LF-GlueServiceRole__LF-GoveredTable-Policy" {
  name = "LF-GoveredTable-Policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "lakeformation:StartTransaction",
            "lakeformation:CommitTransaction",
            "lakeformation:CancelTransaction",
            "lakeformation:ExtendTransaction",
            "lakeformation:DescribeTransaction",
            "lakeformation:ListTransactions",
            "lakeformation:StartQueryPlanning",
            "lakeformation:GetQueryState",
            "lakeformation:GetWorkUnitResults",
            "lakeformation:GetWorkUnits",
            "lakeformation:GetQueryStatistics",
            "lakeformation:GetTableObjects",
            "lakeformation:UpdateTableObjects",
            "lakeformation:DeleteObjectsOnCancel",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}

# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__LF-Workflow-Policy:
resource "aws_iam_role_policy" "LF-GlueServiceRole__LF-Workflow-Policy" {
  name = "LF-Workflow-Policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "iam:PassRole",
          ]
          Effect = "Allow"
          Resource = [
            format("arn:aws:iam::%s:role/LF-GlueServiceRole",data.aws_caller_identity.current.account_id),
            format("arn:aws:iam::%s:role/LakeFormationWorkflowRole",data.aws_caller_identity.current.account_id)
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}

# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.LF-GlueServiceRole__my_s3_policy2:
resource "aws_iam_role_policy" "LF-GlueServiceRole__my_s3_policy2" {
  name = "my_s3_policy2"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = "s3:*"
          Effect = "Allow"
          Resource = [
            format("arn:aws:s3:::xgov-data-eu-west-1-%s/*",data.aws_caller_identity.current.account_id),
            format("arn:aws:s3:::xgov-data-eu-west-1-%s",data.aws_caller_identity.current.account_id)
          ]
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.LF-GlueServiceRole.id
}