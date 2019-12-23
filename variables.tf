variable "company_name" {
  type        = string
  description = "The name of the company the integration is for. Must be alphanumeric."
}

variable "account_alias" {
  description = "The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company_name}-bc"
  type        = string
  default     = ""
}

variable "create_cloudtrail" {
  description = "Indicate whther a new CloudTrail trail should be created. If not - existing_sns_arn and existing_bucket_name are required parameters."
  type        = bool
  default     = true
}

variable "log_file_prefix" {
  description = "The prefix which will be given to all the log files saved to the bucket."
  type        = string
  default     = ""
}

variable "existing_sns_arn" {
  description = "When connecting to an existing CloudTrail trail, please supply the existing trail's SNS ARN."
  type        = string
  default     = null
}

variable "existing_bucket_name" {
  description = "When connecting to an existing CloudTrail trail, please supply the existing trail's bucket name (NOT ARN)."
  type        = string
  default     = null
}

variable "security_account_id" {
  description = "When connecting to an existing CloudTrail trail, which puts its logs in a bucket which is in **another** account"
  type        = string
  default     = ""
}
