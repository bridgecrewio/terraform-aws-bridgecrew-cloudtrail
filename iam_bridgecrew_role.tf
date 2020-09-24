resource aws_iam_role "bridgecrew_account_role" {
  count              = var.create_bridgecrew_connection ? 1 : 0
  name               = "${local.resource_name_prefix}-bridgecrewcwssarole"
  assume_role_policy = data.aws_iam_policy_document.bridgecrew_account_assume_role[0].json
}

data aws_iam_policy_document "bridgecrew_account_assume_role" {
  count = var.create_bridgecrew_connection ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.bridgecrew_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [random_uuid.external_id.result]
    }
  }
}

resource aws_iam_role_policy_attachment "bridgecrew_security_audit" {
  count      = var.create_bridgecrew_connection ? 1 : 0
  role       = aws_iam_role.bridgecrew_account_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource aws_iam_role_policy "bridgecrew_cws_policy" {
  count  = var.create_bridgecrew_connection ? 1 : 0
  name   = "bridgecrew_cws_policy"
  policy = data.aws_iam_policy_document.bridgecrew_cws_policy[0].json
  role   = aws_iam_role.bridgecrew_account_role[0].name
}

data aws_iam_policy_document "bridgecrew_cws_policy" {
  count = var.create_bridgecrew_connection ? 1 : 0
  statement {
    sid = "ConsumeNotifications"
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage",
    ]

    effect = "Allow"

    resources = [aws_sqs_queue.cloudtrail_queue[0].arn]
  }

  statement {
    sid     = "ListLogFiles"
    actions = ["s3:ListBucket"]

    effect = "Allow"

    resources = ["arn:aws:s3:::${local.s3_bucket}/${local.log_file_prefix}AWSLogs/*"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${local.log_file_prefix}AWSLogs/*"]
    }
  }

  statement {
    sid     = "ReadLogFiles"
    actions = ["s3:Get*"]
    effect  = "Allow"

    resources = ["arn:aws:s3:::${local.s3_bucket}/${local.log_file_prefix}AWSLogs/*"]
  }

  statement {
    sid     = "GetAccountAlias"
    actions = ["iam:ListAccountAliases", "cloudwatch:GetMetricData", "sns:ListSubscriptions"]

    effect = "Allow"

    resources = ["*"]
  }
}
