resource "null_resource" "sleep" {
  triggers = {
    always_run = timestamp()
  }
  depends_on=[aws_iam_role.LF-GlueServiceRole,aws_s3_bucket.xgov-data] 

  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        echo "sleep 10s for IAM sync"
        sleep 10 
     EOT
  }
}