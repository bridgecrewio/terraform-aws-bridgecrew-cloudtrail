resource "aws_s3_bucket_lifecycle_configuration" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].bucket
  rule {
    id     = "Delete old log files"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.log_file_expiration
    }

    expiration {
      days = var.log_file_expiration
    }
  }
}
