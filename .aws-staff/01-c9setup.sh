if [[ -z ${TF_VAR_team_number+x} ]];then
echo "TF_VAR_team_number not set"
exit 
fi
echo "Setup c9"
# cd ~/environment
#git clone https://github.com/awsandy/xgov.git
cd ~/environment/xgov/c9setup
./setup
