
resource "aws_s3_bucket_versioning" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
