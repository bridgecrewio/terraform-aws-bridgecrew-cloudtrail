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

variable "existing_kms_key_arn" {
  description = "When connecting to an existing CloudTrail trail, please supply the kms key ARN used to encrypt"
  type        = string
  default     = null
}

variable "security_account_id" {
  description = "When connecting to an existing CloudTrail trail, which puts its logs in a bucket which is in **another** account"
  type        = string
  default     = ""
}

variable "source_account_id" {
  description = "Account that need access to connect to the cloudtrail created by this module"
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

variable "debug_policy" {
  type    = bool
  default = true
}
