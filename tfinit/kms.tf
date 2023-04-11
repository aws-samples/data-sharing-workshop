resource "aws_kms_key" "xgovkey" {
  description = "xgov KMS key"
  enable_key_rotation= true
}


resource "aws_kms_key_policy" "xgovkey" {
  key_id = aws_kms_key.xgovkey.id
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}


output "keyid" {
  value = aws_kms_key.xgovkey.key_id
}




