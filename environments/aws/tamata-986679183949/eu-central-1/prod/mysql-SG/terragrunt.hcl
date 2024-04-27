include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.8.0"
}

inputs = {
  name = "${local.environment}_allow_MySQL"

  vpc_id = dependency.vpc.outputs.vpc_id

  egress_rules        = ["all-all"]
  ingress_rules       = ["mysql-tcp"]
  ingress_cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks

  description = "Allow MySQL inbound traffic"

  tags = local.tags
}
