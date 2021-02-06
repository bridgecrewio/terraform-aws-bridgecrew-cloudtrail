resource "aws_kms_key" "cloudtrail_key" {
  count               = var.create_cloudtrail ? 1 : 0
  description         = "KMS for CloudTrail, shared with Bridgecrew"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.cloudtrail_key[0].json
  tags                = var.common_tags
}

resource "aws_kms_alias" "cloudtrail_key" {
  count         = var.create_cloudtrail ? 1 : 0
  name          = "alias/${local.resource_name_prefix}-CloudtrailKey"
  target_key_id = aws_kms_key.cloudtrail_key[0].key_id
}


data "aws_iam_policy_document" "cloudtrail_key" {
  count = var.create_cloudtrail ? 1 : 0
  statement {
    sid = "AccountOwner"

    actions = ["kms:*"]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.caller.account_id}:root"]
    }

    resources = ["*"]
  }

  statement {
    sid     = "CloudTrailAccess"
    actions = ["kms:*"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = ["*"]
  }

  statement {
    sid     = "BridgecrewDecrypt"
    actions = ["kms:Decrypt"]

    effect = "Allow"

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.caller.account_id]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.caller.account_id}:trail/*"]
    }

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "null_resource" "kms_policy_delay" {
  //  It takes a while for AWS IAM to actually give the relevant permissions
  triggers = {
    build = filemd5("${path.module}/aws_kms_key.cloudtrail_key.tf")
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }

  depends_on = [aws_kms_key.cloudtrail_key]
}
