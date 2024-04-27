include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

}

dependency "key_pair" {
  config_path = "../../key_pair/squid"
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "../../../../../../modules/squid///"
}

 
inputs = {
  aws_key_name = dependency.key_pair.outputs.key_pair_key_name

  vpc_id           = dependency.vpc.outputs.vpc_id
  public_subnet_id = dependency.vpc.outputs.public_subnets[0]

  instance_type        = "t3a.medium"
  instance_profile     = "AmazonSSMRoleForInstancesQuickSetup"
  resource_name_prefix = "squid-ent"

  whitelist = [
    "0.0.0.0/0"
  ]

  tags = merge(local.tags)
}

