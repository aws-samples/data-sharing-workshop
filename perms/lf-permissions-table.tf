resource "aws_lakeformation_permissions" "lf-admin" {
  principal                     = data.aws_iam_role.lf-admin.arn
  permissions                   = ["ALL", "ALTER", "DELETE", "DESCRIBE", "DROP", "INSERT", "SELECT"]
  permissions_with_grant_option = ["ALL", "ALTER", "DELETE", "DESCRIBE", "DROP", "INSERT", "SELECT"]

  lf_tag_policy {
    resource_type = "TABLE"
  
    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public","private","confidential"]
    }
  }

}

resource "aws_lakeformation_permissions" "lf-campaign-manager" {
  principal                     = data.aws_iam_role.lf-campaign-manager.arn
  permissions                   = ["ALTER", "DELETE", "DESCRIBE", "INSERT", "SELECT"]
  permissions_with_grant_option = ["ALTER", "DELETE", "DESCRIBE", "INSERT", "SELECT"]

  lf_tag_policy {
    resource_type = "TABLE"
  
    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public","private"]
    }
  }

}

resource "aws_lakeformation_permissions" "lf-developer" {
  principal                     = data.aws_iam_role.lf-developer.arn
  permissions                   = ["DESCRIBE", "SELECT"]
  permissions_with_grant_option = ["DESCRIBE", "SELECT"]

  lf_tag_policy {
    resource_type = "TABLE"
  
    expression {
      key    = aws_lakeformation_lf_tag.tags-xgov.key
      values = ["public"]
    }
  }
}