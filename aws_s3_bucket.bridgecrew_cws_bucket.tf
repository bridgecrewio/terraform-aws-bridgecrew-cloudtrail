
resource "aws_s3_bucket" "bridgecrew_cws_bucket" {
  #checkov:skip=CKV_AWS_52:Versioning and BC backup is enough
  count         = var.existing_bucket_name == null ? 1 : 0
  force_destroy = true

  bucket = local.bucket_name

  tags = {
    Name = "BridgecrewCWSBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "bridgecrew_cws_bucket_policy_document" {
  count = var.existing_bucket_name == null ? 1 : 0
  statement {
    sid       = "CloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.bridgecrew_cws_bucket[0].arn]
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "CloudTrailWrite"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.bridgecrew_cws_bucket[0].arn}/${local.log_file_prefix}AWSLogs/${data.aws_caller_identity.caller.account_id}/*"]
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["True"]
    }
  }


  dynamic "statement" {
    for_each = var.organization_id != "" ? [var.organization_id] : []

    content {
      sid       = "OrgCloudTrailWrite"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.bridgecrew_cws_bucket[0].arn}/${local.log_file_prefix}AWSLogs/${statement.value}/*"]
      effect    = "Allow"

      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["True"]
      }
    }
  }

  statement {
    sid       = "DenyUnsecureTransport"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.bridgecrew_cws_bucket[0].arn}/*", aws_s3_bucket.bridgecrew_cws_bucket[0].arn]
    effect    = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["False"]
    }
  }
}

resource "aws_s3_bucket_policy" "bridgecrew_cws_bucket_policy" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].id
  policy = data.aws_iam_policy_document.bridgecrew_cws_bucket_policy_document[0].json

  depends_on = [aws_s3_bucket_public_access_block.bridgecrew_cws_bucket]
}
