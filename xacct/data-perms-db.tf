# share the catalog table remotely to 
# remote account 1

resource "aws_lakeformation_permissions" "ra1-db" {
  principal   = format("arn:aws:iam::%s:role/lf-admin",var.remote_acct_1)
  permissions = ["DESCRIBE"]

  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = "sensitivity"
      values = ["public"]
    }
  }
}

# remote account 2

resource "aws_lakeformation_permissions" "ra2-db" {
  principal   = format("arn:aws:iam::%s:role/lf-admin",var.remote_acct_2)
  permissions = ["DESCRIBE"]

  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = "sensitivity"
      values = ["public"]
    }
  }
}


