resource "aws_s3_object_copy" "customers" {
  depends_on=[aws_s3_bucket_server_side_encryption_configuration.xgov-data]
  bucket = aws_s3_bucket.xgov-data.id
  key    = format("raw-data/customers%s/customers%s.csv",var.team_number,var.team_number)
  source = format("event-engine-eu-west-1/xgovdata/customers%s.csv",var.team_number)
}


resource "aws_s3_object_copy" "products" {
  depends_on=[aws_s3_bucket_server_side_encryption_configuration.xgov-data]
  bucket = aws_s3_bucket.xgov-data.id
  key    = "raw-data/products/products.csv"
  source = "event-engine-eu-west-1/xgovdata/products.csv"
}

resource "aws_s3_object_copy" "sales" {
  depends_on=[aws_s3_bucket_server_side_encryption_configuration.xgov-data]
  bucket = aws_s3_bucket.xgov-data.id
  key    = "raw-data/sales/sales.csv"
  source = "event-engine-eu-west-1/xgovdata/sales.csv"
}