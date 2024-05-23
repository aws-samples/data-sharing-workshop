resource "null_resource" "sleep" {
  triggers = {
    always_run = timestamp()
  }
  depends_on=[aws_iam_role.LF-GlueServiceRole,aws_s3_bucket.xgov-data] 

  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        aws s3 cp ~/environment/xgov/data/products.csv s3://${aws_s3_bucket.xgov-data.id}/raw-data/products/products.csv
        aws s3 cp ~/environment/xgov/data/sales.csv s3://${aws_s3_bucket.xgov-data.id}/raw-data/sales/sales.csv
        aws s3 cp ~/environment/xgov/data/customers${var.team_number}.csv s3://${aws_s3_bucket.xgov-data.id}/raw-data/customers${var.team_number}/customers${var.team_number}.csv
     EOT
  }
}