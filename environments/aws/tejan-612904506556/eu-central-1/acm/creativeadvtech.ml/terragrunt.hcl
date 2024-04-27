include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  domain_name = "creativeadvtech.ml"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-acm.git///?ref=v3.2.1"
}

inputs = {
  domain_name = local.domain_name
  subject_alternative_names = [
    "*.dev.tiejan.${local.domain_name}",
    "*.staging.tiejan.${local.domain_name}",
    "*.tiejan.${local.domain_name}",
    "*.${local.domain_name}"
  ]

  wait_for_validation  = false
  validate_certificate = false

  tags = local.tags
}
