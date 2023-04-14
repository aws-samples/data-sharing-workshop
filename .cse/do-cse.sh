source ~/.bash_profile
if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
echo "install/reinstall tools"
../.aws-staff/01-c9setup.sh
echo "pre-provision infrastructure"
../.aws-staff/02-tfinit.sh
echo "setup Lake Formation"
../.aws-staff/03-lf.sh
date
echo "Create EKS Cluster for EMR ~ 20 minutes"
time ./01*.sh
echo "Add EMR to EKS"
time ./02*.sh
echo "Adjust LF permissions for EMR"
./03-lf.sh
echo "Adjust Key Policy for CSE"
./03c-key-policy.sh
echo "Create Spark python code - to client side encrypt customers data"
./04-spark.sh
echo "Run Spark job ~ 6 minutes"
./05-job.sh
date
echo "Pick up workshop from here:"
echo "https://catalog.us-east-1.prod.workshops.aws/workshops/5ffa7541-d02c-486b-baaf-3c3678873c5a/en-US/070-perms-query"