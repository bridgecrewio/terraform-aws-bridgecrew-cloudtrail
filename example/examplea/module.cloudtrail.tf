module "cloudtrail" {
  source       = "../../"
  aws_profile  = "default"
  company_name = "james"
  api_token    = var.api_token
}

variable "api_token" {
  type        = string
  description = "This is your Bridgecrew platform Api token Set as and Environment variable TF_VAR_api_token"
}
