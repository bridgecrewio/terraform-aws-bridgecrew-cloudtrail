output "cloudformation_arn" {
  value = aws_cloudformation_stack.bridgecrew_stack.id
}