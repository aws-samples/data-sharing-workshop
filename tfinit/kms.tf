resource "aws_kms_key" "xgovkey" {
  description = "xgov KMS key"
  enable_key_rotation= true
}


output "keyid" {
  value = aws_kms_key.xgovkey.key_id
}