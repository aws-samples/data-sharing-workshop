# Data lake settings
echo "check you see lf-admin and WSParticipantRole"
aws lakeformation get-data-lake-settings --query DataLakeSettings.DataLakeAdmins --output text | cut -f2- -d'/'
echo 'Version should be "3"'
aws lakeformation get-data-lake-settings --query DataLakeSettings.Parameters --output text
echo "check glue database location is set xgov-data-eu-west-1-*"
aws glue get-databases --query DatabaseList[].LocationUri --output text
echo 'LF-GlueServiceRole check - Should see >= "1"'
aws lakeformation list-permissions --output text | grep LF-GlueServiceRole | wc -l
echo 'IAMAllowedPrincipals - Should see "0"'
aws lakeformation list-permissions --output text | grep IAMAllowedPrincipals | wc -l 