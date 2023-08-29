# Data lake settings
aws lakeformation get-data-lake-settings --query DataLakeSettings.DataLakeAdmins --output text | cut -f2- -d'/' | grep lf-admin
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found lf-admin role as LF admin"
else
    echo "ERROR: did not find lf-admin role as LF admin"
fi
aws lakeformation get-data-lake-settings --query DataLakeSettings.DataLakeAdmins --output text | cut -f2- -d'/' | grep WSParticipantRole
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found WSParticipantRole role as LF admin"
else
    echo "ERROR: did not find WSParticipantRole role as LF admin"
fi
lv=$(aws lakeformation get-data-lake-settings --query DataLakeSettings.Parameters --output text)
if [[ $lv -eq 3 ]]; then
    echo "PASSED: LF verison is 3 found version = $lv"
else
    echo "ERROR: LF verison is not 3 found version = $lv"
fi
aws glue get-databases --query DatabaseList[].LocationUri --output text | grep 's3://xgov-data'
if [[ $? -eq 0 ]]; then
    echo "PASSED: Found s3://xgov-data* as LF location"
else
    echo "ERROR: did not find s3://xgov-data* as LF location"
fi
lg=$(aws lakeformation list-permissions --output text | grep LF-GlueServiceRole | wc -l)
if [[ $lg -lt 1 ]]; then
    echo "ERROR: did not find LF-GlueServiceRole role in LF permissions"
else
    echo "PASSED: found LF-GlueServiceRole role in LF permissions"
fi
ip=$(aws lakeformation list-permissions --output text | grep IAMAllowedPrincipals | wc -l)
if [[ $lg -eq 0 ]]; then
    echo "PASSED: IAMAllowedPrincipals not in LF permissions"

else
    echo "ERROR: IAMAllowedPrincipals found in LF permissions - not expected"
fi
