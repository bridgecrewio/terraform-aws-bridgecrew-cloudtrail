resource "aws_s3_bucket_logging" "bridgecrew_cws_bucket" {
  count         = var.logs_bucket_id != null ? 1 : 0
  bucket        = aws_s3_bucket.bridgecrew_cws_bucket[count.index].id
  target_bucket = var.logs_bucket_id
  target_prefix = "/${local.bucket_name}"
}
