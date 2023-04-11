resource "aws_iam_role" "lf-developer" {
  name = "lf-developer"

  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

}

resource "aws_iam_role_policy_attachment" "lf-developer-attach" {
  role       = aws_iam_role.lf-developer.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role" "lf-campaign-manager" {
  name = "lf-campaign-manager"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "lf-campaign-manager-attach" {
  role       = aws_iam_role.lf-campaign-manager.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect="Allow"
    principals {
      type        = "AWS"
      identifiers = [
        format("arn:aws:iam::%s:role/WSParticipantRole",data.aws_caller_identity.current.account_id),
        format("arn:aws:iam::%s:role/lf-admin",data.aws_caller_identity.current.account_id)
      ]
    }

  }
}








