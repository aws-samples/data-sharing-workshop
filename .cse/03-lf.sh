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
            },
            {
                "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/EMRContainers-JobExecutionRole-at"
            }
        ],
        "CreateDatabaseDefaultPermissions": [],
        "CreateTableDefaultPermissions": [],
        "Parameters": {"CROSS_ACCOUNT_VERSION": "3"}
}
EOF


echo "Adding EMR Role to Lake Formation admins"
aws lakeformation put-data-lake-settings --data-lake-settings file://lf-settings.json

echo "Grant EMRContainers Role ALL on xgov"
cat <<EOF >input.json
{
    "CatalogId": "${accid}",
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/EMRContainers-JobExecutionRole-at"
    },
    "Resource": {
        "Database": {
            "CatalogId": "${accid}",
            "Name": "xgov"
        }
     },
    "Permissions": [
        "ALL"
    ],
    "PermissionsWithGrantOption": []
}
EOF
echo "Adding EMR Role with permissions ALL for database xgov"
aws lakeformation grant-permissions --cli-input-json file://input.json

echo "Grant EMRContainers Role ALL on customers table"
cat <<EOF >input.json
{
    "CatalogId": "${accid}",
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::${accid}:role/EMRContainers-JobExecutionRole-at"
    },
    "Resource": {
        "TABLE": {
            "CatalogId": "${accid}",
            "DatabaseName" "xgov"
            "Name": "customers${TF_VAR_team_number}"
        }
     },
    "Permissions": [
        "ALL"
    ],
    "PermissionsWithGrantOption": []
}
EOF
echo "Adding EMR Role with permissions ALL for table customers"
aws lakeformation grant-permissions --cli-input-json file://input.json



exit
#
# exit as rest shoudl have been done already
#
#
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
#aws glue create-database --database-input file://gluedb.json 2> /dev/null
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
#echo "start crawler"
#aws glue start-crawler --name xgov
#echo "sleeping 2 minutes"
#sleep 120
#aws glue list-crawls --crawler-name xgov --query Crawls[].Summary --output text | grep ':3}'
