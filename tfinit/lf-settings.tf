resource "aws_lakeformation_data_lake_settings" "example" {
  admins = [
    data.aws_iam_role.lf-admin.arn, 
    data.aws_iam_role.WSParticipantRole.arn
    ]
  
}