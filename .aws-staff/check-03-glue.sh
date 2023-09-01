if [[ -z ${TF_VAR_team_number+x} ]]; then
    echo "TF_VAR_team_number not set"
    read -p 'Enter your Team Number 1,2 or 3: ' tn
    if [[ $tn =~ ^[1-3]{1}$ ]]; then
        export TF_VAR_team_number=${tn}
        echo "export TF_VAR_team_number=${tn}" | tee -a ~/.bash_profile
    else
        echo "Please enter a team number between 1 and 3"
        exit
    fi
    

fi
tabs=$(aws glue get-tables --database-name xgov --query TableList[].Name | jq -r .[])
echo $tabs | grep  products > /dev/null
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found products table in glue catalog"
else
    echo "ERROR: did not find products table in glue catalog"
fi
echo $tabs | grep  sales > /dev/null
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found sales table in glue catalog"
else
    echo "ERROR: did not find sales table in glue catalog"
fi
echo $tabs | grep customers${TF_VAR_team_number} > /dev/null
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found customers${TF_VAR_team_number} table in glue catalog"
else
    echo "ERROR: did not find customers${TF_VAR_team_number} table in glue catalog"
fi
