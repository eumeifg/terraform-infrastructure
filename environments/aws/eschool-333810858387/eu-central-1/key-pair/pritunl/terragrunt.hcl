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
  source = "../../../../../../modules/aws/secretsmanager_keypair///"
}

inputs = {
  name_prefix = "pritunl"
  description = "Key pair of pritunl VPN's EC2 instance"
  tags        = local.tags
}

