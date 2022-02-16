resource "aws_s3_bucket_acl" "bridgecrew_cws_bucket" {
  count  = var.existing_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.bridgecrew_cws_bucket[0].id
  acl    = "private"
}
