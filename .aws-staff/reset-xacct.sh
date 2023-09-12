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
if [[ -z ${TF_VAR_remote_acct_1+x} ]]; then
    echo "TF_VAR_remote_acct_1 not set"
    read -p 'Enter Remote Account ID 1: ' a1
    if [[ $a1 =~ ^[0-9]{12}$ ]]; then
        echo "Account 1 = $a1"
        export TF_VAR_remote_acct_1=${a1}
        echo "export TF_VAR_remote_acct_1=${a1}" | tee -a ~/.bash_profile
    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi

fi
if [[ -z ${TF_VAR_remote_acct_2+x} ]]; then
    echo "TF_VAR_remote_acct_2 not set"
    read -p 'Enter Remote Account ID 2: ' a2
    if [[ $a2 =~ ^[0-9]{12}$ ]]; then
        echo "Account 2 = $a2"
        export TF_VAR_remote_acct_2=${a2}
        echo "export TF_VAR_remote_acct_2=${a2}" | tee -a ~/.bash_profile

    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi

fi
ac=$(aws sts get-caller-identity | jq -r .Account)
cracs=$(aws lakeformation list-permissions | grep 'iam:' | grep -e $TF_VAR_remote_acct_1 -e $TF_VAR_remote_acct_2 | sort -u | cut -f6 -d: | wc -l)
if [[ $cracs -ne 2 ]]; then
    echo "WARNING: found $cracs remote accounts in permissions - expected only 2 at this point in the workshop"
fi



xc=$(aws lakeformation list-permissions | grep 'iam:' | grep -v $ac | wc -l)
if [[ $rs -lt 4 ]]; then
    echo "ERROR: Expected to see 4 principlas in LF permissions - got $xc"
else
    echo "PASSED: Found min 4 principals expected"
fi

echo "Revoke Tag Permissions"
racs=$(aws lakeformation list-permissions | grep 'iam:' | grep -e $TF_VAR_remote_acct_1 -e $TF_VAR_remote_acct_2 | sort -u | cut -f6 -d:)

for ra in $racs; do
    cat <<EOF >input.json
    {
        "CatalogId": "$ac",
        "Resource": {
            "LFTag": {
                "CatalogId": "$ac",
                "TagKey": "share",
                "TagValues": ["teams"]
            }    
        }
    }
EOF

    aws lakeformation revoke-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$ra --permissions DESCRIBE ASSOCIATE

    cat <<EOF >input.json
{
    "CatalogId": "$ac",
    "Resource": {
        "LFTag": {
            "CatalogId": "$ac",
            "TagKey": "sensitivity",
            "TagValues": ["public"]
        }    
    }
}
EOF

    aws lakeformation revoke-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$ra --permissions DESCRIBE ASSOCIATE


    cat <<EOF >input.json
{
    "CatalogId": "$ac",
    "Resource": {
        "LFTag": {
            "CatalogId": "$ac",
            "TagKey": "sensitivity",
            "TagValues": ["private"]
        }    
    }
}
EOF

    aws lakeformation revoke-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$ra --permissions DESCRIBE ASSOCIATE




done



echo "Revoke Database permissions"
prins=$(aws lakeformation list-permissions | grep 'iam:' | grep -e $TF_VAR_remote_acct_1 -e $TF_VAR_remote_acct_2 | sort -u | cut -f2- -d':' | jq -r .)
# check db perms
for p in $prins; do

    cat <<EOF >input.json
{
    "CatalogId": "$ac",
    "Resource": {
        "LFTagPolicy": {
            "CatalogId": "$ac",
            "ResourceType": "DATABASE",
            "Expression": [
                {
                    "TagKey": "sensitivity",
                        "TagValues": [
                            "public"
                        ]
                    }
                ]
        }
    }
}
EOF
    aws lakeformation revoke-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$p --permissions DESCRIBE 

done


# check table perms
echo "Revoke Table permissions"
for p in $prins; do

    cat <<EOF >input.json
{
    "CatalogId": "$ac",
    "Resource": {
        "LFTagPolicy": {
                    "CatalogId": "$ac",
                    "ResourceType": "TABLE",
                    "Expression": [
                        {
                            "TagKey": "sensitivity",
                            "TagValues": [
                                "private",
                                "public"
                            ]
                        },
                        {
                            "TagKey": "share",
                            "TagValues": [
                                "teams"
                            ]
                        }
                    ]
        }
    }
}
EOF
    aws lakeformation revoke-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$p --permissions DESCRIBE SELECT



done








rs=$(aws ram get-resource-shares --resource-share-status ACTIVE --resource-owner SELF --query resourceShares[].name | jq -r .[] | grep LakeF | wc -l)
if [[ $rs -lt 4 ]]; then
    echo "ERROR: Expected to see 4 RAM shares - got $rs"
elif [[ $rs -gt 0 ]]; then
    echo "PASSED: Found 0 RAM shares as expected"
else
    echo "WARNING: Expected to see 0 RAM shares - got $rs"
fi