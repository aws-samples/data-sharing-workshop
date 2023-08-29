echo "check you see 25 lf-admin permissions"
aws lakeformation list-permissions --output text | grep lf-admin | wc -l
aws lakeformation list-permissions --output text | grep lf-camp | wc -l
aws lakeformation list-permissions --output text | grep lf-devel | wc -l
echo " check there are 11 tag keys"
aws lakeformation list-lf-tags --query LFTags[].TagKey | jq -r .[] | wc -l
echo "check there are 6 public values"
aws lakeformation list-permissions --output text | grep public | wc -l
echo "check customersX is tagged to share with teams - should see output customersX"
aws lakeformation search-tables-by-lf-tags --expression TagKey=share,TagValues=teams --query TableList[].Table[].Name --output text
