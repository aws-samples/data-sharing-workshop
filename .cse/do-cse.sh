if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
date
echo "Create EKS Cluster"
time ./01*.sh
echo "Add EMR to EKS"
time ./02*.sh
date