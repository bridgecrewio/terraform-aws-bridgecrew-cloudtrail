output "s3_bucket_name" {
  description = "The s3 bucket name for cloudtrail."
  value       = local.s3_bucket
}

output "s3_key_prefix" {
  description = "The s3 log prefix for cloudtrail, inside the bucket."
  value       = var.log_file_prefix
}

output "sns_topic_name" {
  description = "The sns topic cloudtrail will push to."
  value       = local.sns_topic
}

output "kms_key_id" {
  description = "The KMS key cloudtrail will use for encryption"
  value       = local.kms_key
}

output "role_arn" {
  description = "The cross-account access role ARN for Bridgecrew"
  value       = aws_iam_role.bridgecrew_account_role[0].arn
}

output "customer_name" {
  description = "The customer name as defined on Bridgecrew signup"
  value       = var.company_name
}

output "sqs_queue_arn" {
  description = "The SQS queue ARN to share with Bridgecrew for CloudTrail integration"
  value       = aws_sqs_queue.cloudtrail_queue[0].arn
}

output "sqs_queue_url" {
  description = "The SQS queue URL to share with Bridgecrew for CloudTrail integration"
  value       = aws_sqs_queue.cloudtrail_queue[0].id
}

output "deployment_region" {
  description = "The region that the customer ran this module"
  value       = data.aws_region.region.name
}

output "template_version" {
  description = "Bridgecrew.io template version."
  value       = "1.4"
}
