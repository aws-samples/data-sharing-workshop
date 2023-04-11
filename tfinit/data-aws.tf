data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

output "issuer_arn" {
  value = data.aws_iam_session_context.current.issuer_arn
}