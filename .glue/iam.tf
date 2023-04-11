# this role comes from CloudFormatio
data "aws_iam_role" "LF-GlueServiceRole" {
    name = "LF-GlueServiceRole"
}

data "aws_iam_role" "WSParticipantRole" {
    name = "WSParticipantRole"
}

data "aws_iam_role" "lf-admin" {
    name = "lf-admin"
}
