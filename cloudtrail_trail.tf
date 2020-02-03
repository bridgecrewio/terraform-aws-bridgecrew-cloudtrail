resource "aws_cloudtrail" "trail" {
  count          = var.create_cloudtrail ? 1 : 0
  name           = "${local.resource_name_prefix}-${local.account_id}-bridgecrewcws"
  s3_bucket_name = local.s3_bucket
  s3_key_prefix  = var.log_file_prefix

  sns_topic_name = local.sns_topic
  kms_key_id     = local.kms_key

  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.organization_id != ""
  enable_logging                = true

  depends_on = [aws_s3_bucket_policy.bridgecrew_cws_bucket, null_resource.kms_policy_delay]
}

resource "null_resource" "kms_policy_delay" {
  triggers = {
    build = filemd5("${path.module}/kms_cloudtrail_key.tf")
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }

  depends_on = [aws_kms_key.cloudtrail_key]
}

