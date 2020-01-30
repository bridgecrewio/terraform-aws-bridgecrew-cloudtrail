resource "aws_iam_policy" "bridgecrew_cws_policy" {
  count  = var.create_bridgecrew_connection ? 1 : 0
  name   = "bridgecrew_cws_policy"
  policy = data.aws_iam_policy_document.bridgecrew_cws_policy[0].json
}

data "aws_iam_policy_document" "bridgecrew_cws_policy" {
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
    sid = "ListLogFiles"
    actions = [
      "s3:ListBucket",
    ]

    effect = "Allow"

    resources = ["arn:aws:s3:::${local.s3_bucket}/AWSLogs/*"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["AWSLogs/*"]
    }
  }

  statement {
    sid = "ReadLogFiles"
    actions = [
      "s3:Get*",
    ]

    effect = "Allow"

    resources = ["arn:aws:s3:::${local.s3_bucket}/AWSLogs/*"]
  }

  statement {
    sid = "GetAccountAlias"
    actions = [
      "iam:ListAccountAliases",
    ]

    effect = "Allow"

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.debug_policy ? ["Debug"] : []
    content {
      sid = each.value
      actions = [
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailTopics",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:ListPublicKeys",
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy",
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "sns:GetSubscriptionAttributes",
        "sns:GetTopicAttributes",
        "sns:ListSubscriptions",
        "sns:ListSubscriptionsByTopic",
        "sns:ListTopics"
      ]

      effect = "Allow"

      resources = ["*"]
    }
  }
}
