resource "aws_athena_workgroup" "xgov" {
  name = "xgov"

  configuration {
    enforce_workgroup_configuration    = true
    engine_version {
      selected_engine_version = "Athena engine version 3"
    }
    result_configuration {
      #output_location = format("s3://lf-workshop-%s/athena-results/",data.aws_caller_identity.current.account_id)
      output_location = format("s3://%s/athena-results/",aws_s3_bucket.xgov-data.id)
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}