echo "LF - Settings - set Lake Admins"
accid=$(aws sts get-caller-identity --query Account --output text)
cat <<EOF >lf-settings.json
{
        "DataLakeAdmins": [
            {
                "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/lf-admin"
            },
            {
                "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/WSParticipantRole"
            }
        ],
        "CreateDatabaseDefaultPermissions": [],
        "CreateTableDefaultPermissions": [],
        "Parameters": {"CROSS_ACCOUNT_VERSION": "3"}
}
EOF
aws lakeformation put-data-lake-settings --data-lake-settings file://lf-settings.json
#
#
## Revoke IAMAllowedPrincipals - In admin roles and tasks
#
echo "Revoke IAM_ALLOWED_PRINCIPALS"
aws lakeformation revoke-permissions --principal DataLakePrincipalIdentifier=IAM_ALLOWED_PRINCIPALS --resource '{ "Catalog": {}}' --permissions CREATE_DATABASE
#
## Grant LF-GlueService-Role
#
echo "LF Database with location"
s3b=$(aws s3 ls | grep xgov-data | awk '{print $3}')
cat <<EOF >gluedb.json
{
    "Name": "xgov",
    "Description": "xgov",
    "LocationUri": "s3://${s3b}"
}
EOF
aws glue create-database --database-input file://gluedb.json 2> /dev/null
#
## Grant LF-GlueService-Role
#
echo "Grant LF-GlueService-Role"
cat <<EOF >input.json
{
    "CatalogId": "${accid}",
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/LF-GlueServiceRole"
    },
    "Resource": {
        "Database": {
            "CatalogId": "${accid}",
            "Name": "xgov"
        }
     },
    "Permissions": [
        "CREATE_TABLE"
    ],
    "PermissionsWithGrantOption": []
}
EOF
echo "aws lakeformation grant-permissions --cli-input-json file://input.json"
aws lakeformation grant-permissions --cli-input-json file://input.json
#
## Fire xgov crawler 
#
echo "check the Lake Formation setup"
~/environment/xgov/.aws-staff/check-02-lf-setup.sh
echo "start glue crawler"
aws glue start-crawler --name xgov
echo "sleeping ~ 2 minutes"
sleep 130
echo "check we have 3 glue tables"
~/environment/xgov/.aws-staff/check-03-glue.sh
