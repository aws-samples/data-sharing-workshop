echo "check you see 25 lf-admin permissions"
ac=$(aws lakeformation list-permissions --output text | grep lf-admin | wc -l)
if [[ $ac -lt 25 ]];then
    echo "ERROR: expected 25+ lf-admin permissions only got $sc"
else
    echo "PASSED: Found expected 25+ lf-admin permissions"
fi
cc=$(aws lakeformation list-permissions --output text | grep lf-campaign-manager | wc -l)
if [[ $cc -lt 2 ]];then
    echo "ERROR: expected 2 lf-campaign-manager permissions got $cc"
else
    echo "PASSED: Found expected 2 lf-campaign-manager permissions"
fi
dc=$(aws lakeformation list-permissions --output text | grep lf-developer | wc -l)
if [[ $dc -lt 2 ]];then
    echo "ERROR: expected 2 lf-developer permissions got $dc"
else
    echo "PASSED: Found expected 2 lf-developer permissions"
fi
tk=$(aws lakeformation list-lf-tags --query LFTags[].TagKey | jq -r .[] | wc -l)
if [[ $tk -ne 11 ]];then
    echo "ERROR: expected 11 tag keys got $tk"
else
    echo "PASSED: Found expected 11 tag keys"
fi
pv=$(aws lakeformation list-permissions --output text | grep public | wc -l)
if [[ $pv -ne 11 ]];then
    echo "ERROR: expected 6 public values got $pv"
else
    echo "PASSED: Found expected 6 public values"
fi
aws lakeformation search-tables-by-lf-tags --expression TagKey=share,TagValues=teams --query TableList[].Table[].Name --output text | grep customers > /dev/null
if [[ $ip -eq 0 ]]; then
    echo "PASSED: customers table found in share tag"

else
    echo "ERROR: customers table not found in share tag"
fi
