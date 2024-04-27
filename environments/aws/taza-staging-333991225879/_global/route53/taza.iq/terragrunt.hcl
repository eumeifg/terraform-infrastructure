include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-route53.git//modules/zones?ref=v2.2.0"
}

inputs = {
  zones = {
    "taza.iq" = {
      comment = "Public DNS zone for taza project."
    }
  }
  tags = local.tags
}
