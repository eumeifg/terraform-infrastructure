include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "../../../../../../../modules/pritunl///"
}

inputs = {
  aws_key_name = "frappe-key"

  vpc_id           = dependency.vpc.outputs.vpc_id
  public_subnet_id = dependency.vpc.outputs.public_subnets[0]

  instance_type        = "t3.small"
  resource_name_prefix = "pritunl-frappe"
  instance_profile     = "AmazonSSMRoleForInstancesQuickSetup"
  resource_name_prefix_role = "VpnServerRole"

  whitelist = [
    "0.0.0.0/0"  
  ]
}
