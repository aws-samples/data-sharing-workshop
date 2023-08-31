ac=$(aws sts get-caller-identity | jq -r .Account)
cracs=$(aws lakeformation list-permissions | grep 'iam:'| grep -v $ac | sort -u | cut -f6 -d: | wc -l)
if [[ $cracs -ne 2 ]];then
    echo "WARNING: found $cracs remote accounts in permissions - expected only 2 at this point in the workshop"
fi

rs=$(aws ram get-resource-shares --resource-owner SELF --query resourceShares[].name | jq -r .[] | grep LakeF | wc -l)
if [[ $rs -ne 4 ]];then
    echo "ERROR: Expected to see 4 RAM shares - got $rs"
else
    echo "PASSED: Found 4 RAM shares as expected"
fi
ac=$(aws sts get-caller-identity | jq -r .Account)
xc=$(aws lakeformation list-permissions | grep 'iam:' | grep -v $ac | wc -l)
if [[ $rs -lt 4 ]];then
    echo "ERROR: Expected to see 4 principlas in LF permissions - got $xc"
else
    echo "PASSED: Found min 4 principals expected"
fi

racs=$(aws lakeformation list-permissions | grep 'iam:'| grep -v $ac | sort -u | cut -f6 -d:)

for ra in $racs; do
cat << EOF > input.json
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

prins=$(aws lakeformation list-permissions | grep 'iam:' | grep -v $ac | sort -u | cut -f2- -d':' | jq -r .)
# check db perms
for p in $prins; do

cat << EOF > input.json
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
perms=$(aws lakeformation list-permissions --cli-input-json file://input.json --principal DataLakePrincipalIdentifier=$p)
echo $perms | grep DESCRIBE > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $p has DESCRIBE on DATABASE xgov"
else
echo "ERROR: Principal $p does not have DESCRIBE on DATABASE xgov"
fi
done


# check table perms

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
                                "teams"
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
echo "PASSED: Principal $p has SELECT with tags sensitivity: public,private and share: teams TABLE in xgov"
else
echo "ERROR: Principal $p does not have SELECT with tags sensitivity: public,private and share: teams TABLE in xgov"
fi
echo $perms | grep DESCRIBE > /dev/null
if [[ $? -eq 0 ]];then
echo "PASSED: Principal $p has DESCRIBE with tags sensitivity: public,private and share: teams TABLE in xgov"
else
echo "ERROR: Principal $p does not have DESCRIBE with tags sensitivity: public,private and share: teams TABLE in xgov"
fi


done