locals {
  resource_name_prefix = var.resource_name_prefix == "" ? "${var.customer_name}-bc" : var.resource_name_prefix
}

resource "random_string" "external_id" {
  length  = 6
  lower   = false
  special = false
}

resource "aws_cloudformation_stack" "bridgecrew_stack" {
  name         = "${var.customer_name}-bridgecrew"
  template_url = "https://bc-cf-template-890234264427.s3-us-west-2.amazonaws.com/cloud-formation-template.json"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    ResourceNamePrefix : local.resource_name_prefix
    CustomerName : var.customer_name
    ExternalID : random_string.external_id.result
    CreateTrail : var.create_cloudtrail ? "Yes" : "No"
    NewTrailLogFilePrefix : var.create_cloudtrail ? var.log_file_prefix : ""
    ExistingTrailBucketName : var.create_cloudtrail ? "" : var.existing_bucket_name
    ExistingTrailTopicArn : var.create_cloudtrail ? "" : var.existing_sns_arn
  }
}