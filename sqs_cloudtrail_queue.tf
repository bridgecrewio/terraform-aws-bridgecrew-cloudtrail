resource "aws_sqs_queue" "cloudtrail_queue" {
  count                      = var.create_bridgecrew_connection ? 1 : 0
  name                       = "${local.resource_name_prefix}-bridgecrewcws"
  visibility_timeout_seconds = 43200
  policy                     = data.aws_iam_policy_document.cloudtrail_queue[0].json
}

resource "aws_sns_topic_subscription" "cloudtrail_queue" {
  count     = var.create_bridgecrew_connection ? 1 : 0
  topic_arn = local.sns_topic
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.cloudtrail_queue[0].arn
}

data "aws_iam_policy_document" "cloudtrail_queue" {
  count = var.create_bridgecrew_connection ? 1 : 0
  statement {
    sid = "AllowSnsAccess"
    actions = [
      "sqs:SendMessage",
    ]

    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.sns_topic]
    }

    resources = [
      "*",
    ]
  }

  statement {
    sid = "BridgecrewSnsAccess"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ChangeMessageVisibility",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.bridgecrew_account_id}:root"]
    }

    resources = [
      "*",
    ]
  }
}
