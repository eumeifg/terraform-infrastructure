include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "../../../../../../modules/aws/wafv2-ip-set///"
}

inputs = {
  name = "dubai-office-egress"

  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  ## Dubai Office egress address.
  addresses = [
    "91.74.31.240/32",
  ]

  tags = local.tags
}
