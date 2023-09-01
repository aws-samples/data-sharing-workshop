# producer sharing - tag permissions
# to remote account 1
resource "aws_lakeformation_permissions" "ra1-senitivity" {
  principal   = var.remote_acct_1
  permissions = ["DESCRIBE", "ASSOCIATE"]
  lf_tag {
      key    = "sensitivity"
      values = ["public","private"]
    }
}

resource "aws_lakeformation_permissions" "ra1-share" {
  principal   = var.remote_acct_1
  permissions = ["DESCRIBE", "ASSOCIATE"]
  lf_tag {
      key    = "share"
      values = ["teams"]
  }
}

# to remote account 2

resource "aws_lakeformation_permissions" "ra2-senitivity" {
  principal   = var.remote_acct_2
  permissions = ["DESCRIBE", "ASSOCIATE"]
  lf_tag {
      key    = "sensitivity"
      values = ["public","private"]
    }  
}

resource "aws_lakeformation_permissions" "ra2-share" {
  principal   = var.remote_acct_2
  permissions = ["DESCRIBE", "ASSOCIATE"]

  lf_tag {
      key    = "share"
      values = ["teams"]
  }
  
}




