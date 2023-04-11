resource "aws_glue_trigger" "example" {
  name       = "example"
  type       = "ON_DEMAND"
  depends_on = [aws_glue_catalog_database.xgov]



  actions {
    crawler_name = "xgov"
  }
}