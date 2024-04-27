include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "zone" {
  config_path = "../../../_global/route53/internal.creativeadvtech.com"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-acm.git///?ref=v3.2.0"
}

inputs = {
  domain_name = dependency.zone.outputs.route53_zone_name["internal.creativeadvtech.com"]
  zone_id     = dependency.zone.outputs.route53_zone_zone_id["internal.creativeadvtech.com"]

  subject_alternative_names = [
    "*.internal.creativeadvtech.com"
  ]

  wait_for_validation  = false
  validate_certificate = true

  tags = local.tags
}
