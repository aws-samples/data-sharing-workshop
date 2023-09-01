if [[ -z ${TF_VAR_remote_acct_1+x} ]]; then
    echo "TF_VAR_remote_acct_1 not set"
    exit
fi
if [[ -z ${TF_VAR_remote_acct_2+x} ]]; then
    echo "TF_VAR_remote_acct_1 not set"
    exit
fi
#Accept resource shares

for i in $(aws ram get-resource-share-invitations --query resourceShareInvitations[].resourceShareInvitationArn --output text); do
    echo "Accepting RAM share $i"
    aws ram accept-resource-share-invitation --resource-share-invitation-arn $i
done

if [[ $TF_VAR_team_number -eq 1 ]]; then
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers2","TargetTable":{"CatalogId":$TF_VAR_remote_acct_1,"DatabaseName":"xgov","Name":"customers2"}}'
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers3","TargetTable":{"CatalogId":$TF_VAR_remote_acct_2,"DatabaseName":"xgov","Name":"customers3"}}'
fi


if [[ $TF_VAR_team_number -eq 2 ]]; then
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers1","TargetTable":{"CatalogId":$TF_VAR_remote_acct_1,"DatabaseName":"xgov","Name":"customers1"}}'
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers3","TargetTable":{"CatalogId":$TF_VAR_remote_acct_2,"DatabaseName":"xgov","Name":"customers3"}}'
fi


if [[ $TF_VAR_team_number -eq 3 ]]; then
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers1","TargetTable":{"CatalogId":$TF_VAR_remote_acct_1,"DatabaseName":"xgov","Name":"customers1"}}'
    aws glue create-table --database-name xgov --table-input '{"Name":"r-customers2","TargetTable":{"CatalogId":$TF_VAR_remote_acct_2,"DatabaseName":"xgov","Name":"customers2"}}'
fi



