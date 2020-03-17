locals {
  resource_name_prefix  = var.account_alias == "" ? "${var.company_name}-bc" : "${var.company_name}-${var.account_alias}"
  bridgecrew_account_id = "890234264427"
  bridgecrew_sns_topic  = "arn:aws:sns:${data.aws_region.region.name}:${local.bridgecrew_account_id}:handle-customer-actions"
  log_file_prefix       = var.log_file_prefix == "" ? "" : "${var.log_file_prefix}/"
  profile_str           = var.aws_profile != null ? "--profile ${var.aws_profile}" : ""

  s3_bucket  = var.existing_bucket_name == null ? aws_s3_bucket.bridgecrew_cws_bucket[0].bucket : var.existing_bucket_name
  kms_key    = var.create_cloudtrail ? aws_kms_key.cloudtrail_key[0].arn : null
  sns_topic  = var.existing_sns_arn == null ? aws_sns_topic.cloudtrail_to_bridgecrew[0].arn : var.existing_sns_arn
}

data aws_caller_identity "caller" {}

data aws_region "region" {}

resource random_string "external_id" {
  length  = 6
  lower   = false
  special = false
}
