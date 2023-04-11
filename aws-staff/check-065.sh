echo "check you see 3 tables"
aws glue get-tables --database-name xgov --query TableList[].Name --output text
