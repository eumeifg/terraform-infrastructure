include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

}

dependency "zone_creativeadvtech_ml" {
  config_path = "../../../../creative-root-310830963532/_global/route53/creativeadvtech.ml/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-acm.git///?ref=v3.2.0"
}


inputs = {
  domain_name = dependency.zone_creativeadvtech_ml.outputs.route53_zone_name["creativeadvtech.ml"]
  zone_id     = dependency.zone_creativeadvtech_ml.outputs.route53_zone_zone_id["creativeadvtech.ml"]

  subject_alternative_names = [
    "*.creativeadvtech.ml",
    "*.iqnbb.creativeadvtech.ml"
  ]

  wait_for_validation  = false
  validate_certificate = false

  tags = local.tags
}
