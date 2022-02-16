resource "aws_s3_bucket_server_side_encryption_configuration" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].bucket


  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.kms_key
      sse_algorithm     = "aws:kms"
    }
  }

}
