locals {
  bucket_name = "${local.resource_name_prefix}-bridgecrewcws-${local.account_id}"
}

resource "aws_s3_bucket" "bridgecrew_cws_bucket" {
  count = var.existing_bucket_name == null ? 1 : 0

  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "Delete old log files"
    enabled = true

    noncurrent_version_expiration {
      days = var.log_file_expiration
    }

    expiration {
      days = var.log_file_expiration
    }
  }

  dynamic "logging" {
    for_each = var.logs_bucket_id != null ? [var.logs_bucket_id] : []

    content {
      target_bucket = logging.value
      target_prefix = "/${local.bucket_name}"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = local.kms_key
        sse_algorithm     = "aws:kms"
      }
    }
  }

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

data "aws_iam_policy_document" "bridgecrew_cws_bucket" {
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
    resources = ["${aws_s3_bucket.bridgecrew_cws_bucket[0].arn}/${local.log_file_prefix}AWSLogs/${var.source_account_id != "" ? var.source_account_id : local.account_id}/*"]
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

resource "aws_s3_bucket_policy" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].id
  policy = data.aws_iam_policy_document.bridgecrew_cws_bucket[0].json
}
