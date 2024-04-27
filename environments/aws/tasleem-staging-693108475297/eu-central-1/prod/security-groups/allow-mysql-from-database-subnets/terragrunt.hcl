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
  config_path = "../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.17.1"
}

inputs = {
  name        = "${local.environment}-allow-mysql-from-database-subnets"
  description = "Allow MySQL inbound traffic from database subnets."
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_rules       = ["mysql-tcp"]
  ingress_cidr_blocks = dependency.vpc.outputs.database_subnets_cidr_blocks

  egress_rules        = ["all-all"]

  tags = local.tags
}
