resource "aws_lakeformation_resource_lf_tags" "db-xgov" {
  database {
    name = "xgov"
  }

# no share tag - just the public tag
  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}

# customersX table

resource "aws_lakeformation_resource_lf_tags" "table-customers" {
  table {
    database_name="xgov"
    name=format("customers%s",var.team_number)
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-share.key
    value = "teams"
  }
}


resource "aws_lakeformation_resource_lf_tags" "tables-products" {
  table {
    database_name="xgov"
    name="products"
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}

resource "aws_lakeformation_resource_lf_tags" "tables-sales" {
  table {
    database_name="xgov"
    name="sales"
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}






#### customersX columns

resource "aws_lakeformation_resource_lf_tags" "table-customers-public" {
  table_with_columns {
    database_name="xgov"
    name=format("customers%s",var.team_number)
    column_names=["Customer_ID"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}


resource "aws_lakeformation_resource_lf_tags" "table-customers-private" {
  table_with_columns {
    database_name="xgov"
    name=format("customers%s",var.team_number)
    column_names=["prefix","first_name","middle_name","last_name","suffix","gender"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "private"
  }
}

resource "aws_lakeformation_resource_lf_tags" "table-customers-confidential" {
  table_with_columns {
    database_name="xgov"
    name=format("customers%s",var.team_number)
    column_names=["dob","address"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "confidential"
  }
}

### products

resource "aws_lakeformation_resource_lf_tags" "table-products-public" {
  table_with_columns {
    database_name="xgov"
    name="products"
    column_names=["product key","sku #","product name","product description","brand","product type"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}


resource "aws_lakeformation_resource_lf_tags" "table-products-private" {
  table_with_columns {
    database_name="xgov"
    name="products"
    column_names=["category","sub category"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "private"
  }
}

resource "aws_lakeformation_resource_lf_tags" "table-products-confidential" {
  table_with_columns {
    database_name="xgov"
    name="products"
    column_names=["unit price"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "confidential"
  }
}

### sales

resource "aws_lakeformation_resource_lf_tags" "table-sales-public" {
  table_with_columns {
    database_name="xgov"
    name="sales"
    column_names=["customer_id","product_id"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "public"
  }
}


resource "aws_lakeformation_resource_lf_tags" "table-sales-private" {
  table_with_columns {
    database_name="xgov"
    name="sales"
    column_names=["txn_date","quantity"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "private"
  }
}

resource "aws_lakeformation_resource_lf_tags" "table-sales-confidential" {
  table_with_columns {
    database_name="xgov"
    name="sales"
    column_names=["total_sales"]
  }

  lf_tag {
    key   = aws_lakeformation_lf_tag.tags-xgov.key
    value = "confidential"
  }
}



output "team_number" {
value=var.team_number
}
