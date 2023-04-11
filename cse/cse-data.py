import sys
from pyspark.sql import SparkSession

if __name__ == "__main__":

    spark = SparkSession.builder.appName("cse-data").enableHiveSupport().getOrCreate()

    df = spark.read.csv('s3://xgov-data-eu-west-2-566972129213/raw-data/customers1/customers1.csv', header=True)
    print("Total customers: " + str(df.count()))

    #Registers this DataFrame as a temporary table using the given name.
    #The lifetime of this temporary table is tied to the SparkSession that was used to create this DataFrame.

    df.registerTempTable("customers_table")


    df.write.parquet('s3://xgov-data-eu-west-2-566972129213/customers1.parquet')
    print("Encrypt - KMS- CSE write to s3 completed")

    dbName = "xgov"
    print("Create glue db ..")
    spark.sql("CREATE database if not exists " + dbName)
    print("use glue db .. +dbname")
    spark.sql("USE " + dbName)

    spark.sql("DROP table customers1")

    print("Create glue table..")
    spark.sql("CREATE table if not exists customers1 USING PARQUET LOCATION '" + "s3://xgov-data-eu-west-2-566972129213/customers1/customers1.parquet" + "' TBLPROPERTIES ('has_encrypted_data'='true') AS SELECT * from customers_table ")
    print("Finished glue ....")


    spark.stop()
