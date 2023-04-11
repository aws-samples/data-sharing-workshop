resource "aws_s3_bucket" "xgov-data" {

  bucket = format("xgov-data-%s-%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id)

  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production
  // usage
  force_destroy = true



  lifecycle {
    ignore_changes = [bucket]
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.xgov-data.id


  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.xgovkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_versioning" "terraform_state" {
  # Enable versioning so we can see the full revision history of our
  # state files
  bucket = aws_s3_bucket.xgov-data.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "pub_block_state" {
  bucket = aws_s3_bucket.xgov-data.id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}
