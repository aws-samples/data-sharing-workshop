## Client Side Encryption of Data

This section uses a script ./do-cse.sh that:

1. Automates part for the workshop setup

* Cloud9 tools installation
* Creating some base resources with Terraform
* Running a Glue crawler over the sample data 


2. Prepares EMR to client side encrypt the customersX.csv data using a KMS key

* Create a EKS cluster with Fargate timing ~ 20 minutes
* Add EMR to the EKS Cluster~ 1 minute
* Run a Spark Job ~ 6 minutes
* * Reads the customersX.csv data
* * Write the data to Parquet with client-side encryption
* * Updates the Glue Catalog

### Continue with workshop

  [Set Lake Formation permissions](https://catalog.us-east-1.prod.workshops.aws/workshops/5ffa7541-d02c-486b-baaf-3c3678873c5a/en-US/070-perms-query)


In order for the workshop to complete we need to make a minor change to the sales schema - chnage customer-id to type "string" (orginally it was bigint)




