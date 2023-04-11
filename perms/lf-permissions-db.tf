resource "aws_lakeformation_permissions" "db-xgov-lf-admin" {
  principal   = data.aws_iam_role.lf-admin.arn
  permissions = ["ALL"]

  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public","private","confidential"]
    }
  }
}

resource "aws_lakeformation_permissions" "db-xgov-lf-campaign-manager" {
  principal   = data.aws_iam_role.lf-campaign-manager.arn
  permissions = ["ALL"]

  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public","private","confidential"]
    }
  }
}

resource "aws_lakeformation_permissions" "db-xgov-lf-developer" {
  principal   = data.aws_iam_role.lf-developer.arn
  permissions = ["ALL"]

  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public","private","confidential"]
    }
  }
}


