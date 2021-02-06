locals {
  bucket_name = "${local.resource_name_prefix}-bridgecrewcws-${data.aws_caller_identity.caller.account_id}"
}
