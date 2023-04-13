if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION=$(aws configure get region)
export S3_BUCKET=s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}


cat > cse-data.py <<EOF
import sys
from pyspark.sql import SparkSession

if __name__ == "__main__":

    spark = SparkSession.builder.appName("cse-data").enableHiveSupport().getOrCreate()

    df = spark.read.csv('${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.csv', header=True)
    print("Total customers: " + str(df.count()))

    #Registers this DataFrame as a temporary table using the given name.
    #The lifetime of this temporary table is tied to the SparkSession that was used to create this DataFrame.

    df.registerTempTable("customers_table")

    df.write.parquet('${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.parquet')
    print("Encrypt - KMS - CSE write to s3 completed")


    dbName = "xgov"
    print("use glue db .. " + dbName)
    spark.sql("USE " + dbName)
    print("delete table if exists customers${TF_VAR_team_number}")
    spark.sql("DELETE TABLE IF EXISTS customers${TF_VAR_team_number})
    print("Create glue table..")
    spark.sql("CREATE table if not exists customers${TF_VAR_team_number} USING PARQUET LOCATION '" + "${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.parquet" + "' TBLPROPERTIES ('has_encrypted_data'='true') AS SELECT * from customers_table ")
    print("Finished glue ....")

    spark.stop()
EOF

