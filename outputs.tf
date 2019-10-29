output "cloudformation_arn" {
  value       = aws_cloudformation_stack.bridgecrew_stack.id
  description = "The ID of the CloudFormation that was created."
}