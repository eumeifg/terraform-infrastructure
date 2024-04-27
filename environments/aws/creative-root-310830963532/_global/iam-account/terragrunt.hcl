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
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-iam.git//modules/iam-account?ref=v4.2.0"
}

###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/4.2.0/submodules/iam-account?tab=inputs
###########################################################
inputs = {
  account_alias = local.environment

  #  minimum_password_length = 10
  #
  #  password_reuse_prevention = false
  #
  #  require_symbols = false
}
