if [[ -z ${TF_VAR_central_acct+x} ]]; then
    echo "TF_VAR_central_acct not set"
    read -p 'Enter Remote Account ID for Central Account: ' c1
    if [[ $c1 =~ ^[0-9]{12}$ ]]; then
        echo "Central Account = $c1"
        export TF_VAR_central_acct=${c1}
        echo "export TF_VAR_central_acct=${c1}" | tee -a ~/.bash_profile
        
    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi
    
fi
ac=$(aws sts get-caller-identity | jq -r .Account)
cracs=$(aws lakeformation list-permissions | grep 'iam:'| grep $TF_VAR_central_acct | sort -u | cut -f6 -d: | wc -l)
if [[ $cracs -ne 1 ]];then
    echo "WARNING: found $cracs remote accounts in permissions - expected 1 at this point in the workshop"
fi

rs=$(aws ram get-resource-shares --resource-owner SELF --query resourceShares[].name | jq -r .[] | grep LakeF | wc -l)
if [[ $rs -ne 6 ]];then
    echo "ERROR: Expected to see 6 RAM shares - got $rs"
else
    echo "PASSED: Found 6 RAM shares as expected"
fi

xc=$(aws lakeformation list-permissions | grep 'iam:' | grep -v $ac | wc -l)
if [[ $rs -lt 5 ]];then
    echo "ERROR: Expected to see 5 principlas in LF permissions - got $xc"
else
    echo "PASSED: Found min 5 principals expected"
fi

racs=$(aws lakeformation list-permissions | grep 'iam:'| grep $TF_VAR_central_acct | sort -u | cut -f6 -d:)

for ra in $racs; do
cat << EOF > input.json
{
    "CatalogId": "$ac",
    "Resource": {
        "LFTag": {
            "CatalogId": "$ac",
            "TagKey": "share",
            "TagValues": ["central"]
        }    
    }
}
EOF
perms=$(aws lakeformation list-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$ra)
echo $perms | grep DESCRIBE > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $ra has DESCRIBE on tag share value teams"
else
echo "ERROR: Principal $ra does not have DESCRIBE on tag share value teams"
fi
echo $perms | grep ASSOCIATE  > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $ra has ASSOCIATE on tag share value teams"
else
echo "ERROR: Principal $ra does not have ASSOCIATE on tag share value teams"
fi

cat << EOF > input.json
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
perms=$(aws lakeformation list-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$ra)
echo $perms | grep DESCRIBE > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $ra has DESCRIBE on tag sensitivity value public"
else
echo "ERROR: Principal $ra does not have DESCRIBE on tag tag sensitivity value public"
fi
echo $perms | grep ASSOCIATE  > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $ra has ASSOCIATE on tag tag sensitivity value public"
else
echo "ERROR: Principal $ra does not have ASSOCIATE on tag tag sensitivity value public"
fi

done



# check table perms
prins=$(aws lakeformation list-permissions | grep 'iam:' | grep $TF_VAR_central_acct | sort -u | cut -f2- -d':' | jq -r .)

for p in $prins; do

cat << EOF > input.json
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
                                "central"
                            ]
                        }
                    ]
        }
    }
}
EOF
perms=$(aws lakeformation list-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$p)
echo $perms | grep SELECT > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $p has SELECT with tags sensitivity: public,private and share: central on TABLE in xgov"
else
echo "ERROR: Principal $p does not have SELECT with tags sensitivity: public,private and share: central on TABLE in xgov"
fi
echo $perms | grep DESCRIBE > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $p has DESCRIBE with tags sensitivity: public,private and share: central TABLE in xgov"
else
echo "ERROR: Principal $p does not have DESCRIBE with tags sensitivity: public,private and share: central TABLE in xgov"
fi


done