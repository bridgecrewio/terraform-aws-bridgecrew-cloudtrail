output "s3_bucket_name" {
  description = "The s3 bucket name for cloudtrail."
  value       = module.cloudtrail.s3_bucket_name
}

output "s3_key_prefix" {
  description = "The s3 log prefix for cloudtrail, inside the bucket."
  value       = module.cloudtrail.s3_key_prefix
}

output "sns_topic_name" {
  description = "The sns topic cloudtrail will push to."
  value       = module.cloudtrail.sns_topic_name
}

output "kms_key_id" {
  description = "The KMS key cloudtrail will use for encryption"
  value       = module.cloudtrail.kms_key_id
}

output "role_arn" {
  description = "The cross-account access role ARN for Bridgecrew"
  value       = module.cloudtrail.role_arn
}

output "customer_name" {
  description = "The customer name as defined on Bridgecrew signup"
  value       = module.cloudtrail.customer_name
}

output "sqs_queue_arn" {
  description = "The SQS queue ARN to share with Bridgecrew for CloudTrail integration"
  value       = module.cloudtrail.sqs_queue_arn
}

output "sqs_queue_url" {
  description = "The SQS queue URL to share with Bridgecrew for CloudTrail integration"
  value       = module.cloudtrail.sqs_queue_url
}

output "deployment_region" {
  description = "The region that the customer ran this module"
  value       = module.cloudtrail.deployment_region
}

output "template_version" {
  description = "Bridgecrew.io template version."
  value       = "1.5"
}
