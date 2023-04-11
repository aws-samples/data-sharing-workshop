resource "aws_lakeformation_permissions" "xgov-db-glue" {
  principal   = data.aws_iam_role.LF-GlueServiceRole.arn
  permissions = ["CREATE_TABLE", "ALTER", "DROP"]
  permissions_with_grant_option=["CREATE_TABLE", "ALTER", "DROP"]
  depends_on = [
    aws_glue_catalog_database.xgov
  ]
  database {
    name       = aws_glue_catalog_database.xgov.name
    catalog_id = data.aws_caller_identity.current.account_id
  }
}


