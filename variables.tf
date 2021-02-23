variable "company_name" {
  description = "The name of the company the integration is for. Must be alphanumeric."
  type        = string
}

variable "account_alias" {
  description = "The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company_name}-bc"
  type        = string
  default     = ""
}

variable "create_cloudtrail" {
  description = "Indicate whether a new CloudTrail trail should be created. If not - existing_sns_arn and existing_bucket_name are required parameters."
  type        = bool
  default     = true
}

variable "create_bridgecrew_connection" {
  description = "Indicate whether the SQS queue and IAM policies for Bridgecrew need to be set up.  This may be false if you are connecting a cloudtrail in a new account to an existing bucket."
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

variable "organization_id" {
  description = "ID or the organization (for org-wide cloudtrails)"
  type        = string
  default     = ""
}

variable "logs_bucket_id" {
  description = "Bucket to place access logs from the cloudtrail bucket"
  type        = string
  default     = null
}

variable "log_file_expiration" {
  type    = number
  default = 30
}

variable "aws_profile" {
  type        = string
  description = "The profile that was used to deploy this module. If the default profile / default credentials are used, set this value to null."
}

variable "api_token" {
  type        = string
  description = "This is your Bridgecrew platform Api token Set as and Environment variable TF_VAR_api_token"
}

variable "bridgecrew_account_id" {
  type        = string
  description = "The Account number of Bridgecrew. Internal use only"
  default     = "890234264427"
}

variable "topic_name" {
  type        = string
  description = "The SNS topic name for Bridgecrew integration. Internal use only"
  default     = "handle-customer-actions"
}
