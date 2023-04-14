if [[ -z ${TF_VAR_team_number+x} ]]; then
  echo "TF_VAR_team_number not set"
  exit
fi
# get KeyID
export KeyID=$(cd ~/environment/xgov/tfinit && terraform output | grep keyid | cut -f2 -d'=' | tr -d ' "')
#
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION=$(aws configure get region)
export VIRTUAL_CLUSTER_ID=$(aws emr-containers list-virtual-clusters --states RUNNING --query virtualClusters[].id --output text)
export EMR_ROLE_ARN=$(aws iam get-role --role-name EMRContainers-JobExecutionRole-at --query Role.Arn --output text)
export S3_BUCKET=s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}
echo $VIRTUAL_CLUSTER_ID
echo $EMR_ROLE_ARN
echo $S3_BUCKET
echo "KeyID=$KeyID"
aws s3 cp cse-data.py ${S3_BUCKET}/scripts/cse-data.py
# recopy source file
aws s3 cp ../data/customers${TF_VAR_team_number}.csv s3://xgov-data-${AWS_REGION}-${ACCOUNT_ID}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.csv
aws s3 rm ${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.parquet --recursive
cat >cse-data.json <<EOF

{
  "name": "spark-python-in-s3-encrypt-cse-kms-write", 
  "virtualClusterId": "${VIRTUAL_CLUSTER_ID}",
  "executionRoleArn": "${EMR_ROLE_ARN}",
  "releaseLabel": "emr-6.9.0-latest", 
  "jobDriver": {
    "sparkSubmitJobDriver": {
      "entryPoint": "${S3_BUCKET}/scripts/cse-data.py", 
       "sparkSubmitParameters": "--conf spark.executor.instances=4 --conf spark.driver.cores=2  --conf spark.executor.memory=20G --conf spark.driver.memory=20G --conf spark.executor.cores=2"
    }
  }, 
  "configurationOverrides": {
    "applicationConfiguration": [
      {
        "classification": "spark-defaults", 
        "properties": {
          "spark.dynamicAllocation.enabled":"false",
          "spark.hadoop.hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
         }
       },
       {
         "classification": "emrfs-site", 
         "properties": {
          "fs.s3.cse.enabled":"true",
          "fs.s3.cse.encryptionMaterialsProvider":"com.amazon.ws.emr.hadoop.fs.cse.KMSEncryptionMaterialsProvider",
          "fs.s3.cse.kms.keyId": "${KeyID}"
         }
      }
    ], 
    "monitoringConfiguration": {
      "persistentAppUI": "ENABLED", 
      "cloudWatchMonitoringConfiguration": {
        "logGroupName": "/emr-containers/jobs", 
        "logStreamNamePrefix": "cse-data"
      }, 
      "s3MonitoringConfiguration": {
        "logUri": "${S3_BUCKET}/logs/"
      }
    }
  }
}
EOF
date
job=$(aws emr-containers start-job-run --cli-input-json file://cse-data.json)
echo $job | jq .
jid=$(echo $job | jq -r .id)
if [[ $jid != "" ]]; then
  date
  echo "waiting for the spark job $jid on virtual EMR cluster $VIRTUAL_CLUSTER_ID     ~6 minutes"
  js=$(aws emr-containers describe-job-run --virtual-cluster-id $VIRTUAL_CLUSTER_ID --id $jid --query jobRun.state --output text)
  while [[ $js != "COMPLETED" ]] && [[ $js != "FAILED" ]]; do
    echo "Current state of job = $js"
    sleep 10
    js=$(aws emr-containers describe-job-run --virtual-cluster-id $VIRTUAL_CLUSTER_ID --id $jid --query jobRun.state --output text)
  done
  echo "Final state of job = $js"
fi
if [[ $js == "COMPLETED" ]];then
  aws s3 rm ${S3_BUCKET}/raw-data/customers${TF_VAR_team_number}/customers${TF_VAR_team_number}.csv
fi
