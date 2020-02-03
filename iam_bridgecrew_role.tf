resource "aws_iam_role" "bridgecrew_account_role" {
  count              = var.create_bridgecrew_connection ? 1 : 0
  name               = "${local.resource_name_prefix}-bridgecrewcwssarole"
  assume_role_policy = data.aws_iam_policy_document.bridgecrew_account_assume_role[0].json
}

data "aws_iam_policy_document" "bridgecrew_account_assume_role" {
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
      values   = [random_string.external_id.result]
    }
  }
}

resource "aws_iam_role_policy_attachment" "bridgecrew_security_audit" {
  count      = var.create_bridgecrew_connection ? 1 : 0
  role       = aws_iam_role.bridgecrew_account_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "bridgecrew_cloud_formation" {
  count      = var.create_bridgecrew_connection ? 1 : 0
  role       = aws_iam_role.bridgecrew_account_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "bridgecrew_cws_policy" {
  count      = var.create_bridgecrew_connection ? 1 : 0
  role       = aws_iam_role.bridgecrew_account_role[0].name
  policy_arn = aws_iam_policy.bridgecrew_cws_policy[0].arn
}
