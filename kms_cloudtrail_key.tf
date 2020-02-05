resource "aws_kms_key" "cloudtrail_key" {
  count               = var.create_cloudtrail ? 1 : 0
  description         = "KMS for CloudTrail, shared with Bridgecrew"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.cloudtrail_key[0].json
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
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    resources = ["*"]
  }

  statement {
    sid = "CloudTrailAccess"
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
      values   = [var.source_account_id != "" ? var.source_account_id : local.account_id]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.source_account_id != "" ? var.source_account_id : local.account_id}:trail/*"]
    }

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}
