module "cloudtrail" {
  source       = "../../"
  common_tags  = var.common_tags
  company_name = "examplea"
  aws_profile  = "default"
}
