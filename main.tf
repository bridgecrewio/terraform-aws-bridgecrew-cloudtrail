locals {
  resource_name_prefix  = var.account_alias == "" ? "${var.company_name}-bc" : "${var.company_name}-${var.account_alias}"
  bridgecrew_account_id = "890234264427"
  bridgecrew_sns_topic  = "arn:aws:sns:${data.aws_region.region.name}:${local.bridgecrew_account_id}:topic/handle-customer-actions"
  log_file_prefix       = var.log_file_prefix == "" ? "" : "${var.log_file_prefix}/"
  profile_str           = var.aws_profile ? "--profile ${var.aws_profile}" : ""

  s3_bucket  = var.existing_bucket_name == null ? aws_s3_bucket.bridgecrew_cws_bucket[0].bucket : var.existing_bucket_name
  kms_key    = var.existing_kms_key_arn == null ? aws_kms_key.cloudtrail_key[0].arn : var.existing_kms_key_arn
  sns_topic  = var.existing_sns_arn == null ? aws_sns_topic.cloudtrail_to_bridgecrew[0].arn : var.existing_sns_arn
  account_id = data.aws_caller_identity.caller.account_id
}

data "aws_caller_identity" "caller" {}

data "aws_region" "region" {}

resource "random_string" "external_id" {
  length  = 6
  lower   = false
  special = false
}

data template_file "message" {
  filename = "${path.module}/message.json"
  vars {
    request_type         = "Create"
    bridgecrew_sns_topic = local.bridgecrew_sns_topic
    customer_name        = var.company_name
    account_id           = local.account_id
    external_id          = random_string.external_id.result
    logging_account_id   = var.source_account_id != "" ? var.source_account_id : local.account_id
    sqs_queue_url        = aws_sqs_queue.cloudtrail_queue.id
    role_arn             = aws_iam_role.bridgecrew_account_role.arn
    region               = data.aws_region.region.id
  }
}

resource "null_resource" "update_bridgecrew" {
  count = var.create_bridgecrew_connection ? 1 : 0
  triggers = {
    build = sha256(data.template_file.message.rendered)
  }

  provisioner "local-exec" {
    command = "aws sns ${local.profile_str} --region ${data.aws_region.region.id} publish --topic-arn ${local.bridgecrew_sns_topic} --message \"${data.template_file.message.rendered}\""
  }
}

resource "null_resource" "disconnect_bridgecrew" {
  count = var.create_bridgecrew_connection ? 1 : 0

  provisioner "local-exec" {
    command = "aws sns ${local.profile_str} --region ${data.aws_region.region.id} publish --topic-arn ${local.bridgecrew_sns_topic} --message \"${replace("Create", "Delete", data.template_file.message.rendered)}\""
    when    = "destroy"
  }
}
