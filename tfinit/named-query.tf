resource "aws_athena_named_query" "join" {
  name      = "customer-total-sales-by-product"
  workgroup = aws_athena_workgroup.xgov.name
  database  = "xgov"
  query     = format("SELECT p.\"product key\" AS PRODUCTKEY, p.\"product type\" AS PRODUCTTYPE, c.\"customer_id\" AS CUSTOMERID,c.first_name AS FIRSTNAME, c.last_name AS LASTNAME, SUM(s.total_sales) as TOTALSALES FROM sales s inner join customers%s c on s.customer_id=c.customer_id inner join products p on s.product_id=p.\"product key\" group by 1,2,3,4,5 order by 6 desc",var.team_number)
}
