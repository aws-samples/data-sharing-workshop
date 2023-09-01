echo 'check there are "4" shares'
rs=$(aws ram get-resource-shares --resource-share-status ACTIVE --resource-owner SELF --query resourceShares[].name | jq -r .[] | grep LakeF | wc -l)
if [[ $rs -ne 4 ]];then
    echo "ERROR: Expected to see 4 RAM shares - got $rs"
else
    echo "PASSED: Found 4 RAM shares as expected"
fi