resource "aws_sns_topic" "cloudtrail_to_bridgecrew" {
  count             = var.existing_sns_arn == null ? 1 : 0
  name              = "${local.resource_name_prefix}-bridgecrewcws"
}

data "aws_iam_policy_document" "cloudtrail_to_bridgecrew" {
  count = var.existing_sns_arn == null ? 1 : 0
  statement {
    sid     = "CloudTrailPublish"
    actions = ["SNS:Publish"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = ["*"]
  }
}

resource "aws_sns_topic_policy" "cloudtrail_to_bridgecrew" {
  count  = var.existing_sns_arn == null ? 1 : 0
  arn    = aws_sns_topic.cloudtrail_to_bridgecrew[0].arn
  policy = data.aws_iam_policy_document.cloudtrail_to_bridgecrew[0].json
}

