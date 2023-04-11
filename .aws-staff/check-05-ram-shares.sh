echo 'check there are "4" shares'
aws ram get-resource-shares --resource-owner SELF --query resourceShares[].name | jq -r .[] | grep LakeF | wc -l