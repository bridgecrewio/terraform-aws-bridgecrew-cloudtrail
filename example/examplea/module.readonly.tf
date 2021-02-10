module "cloudtrail" {
  source      = "../../"
  org_name    = "jameswoolfen"
  aws_profile = "default"
  api_token   = var.api_token
}
