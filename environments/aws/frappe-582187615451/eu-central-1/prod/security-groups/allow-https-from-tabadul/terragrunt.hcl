include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../../vpc"
}


terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.16.2"
}

inputs = {

  name        = "${local.environment}-allow-https-from-tabadul"
  description = "Allow https from Tabadul Offices  "
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "whitelisting from Tabadul Offices"
      cidr_blocks = "109.224.17.16/29"
    }
  ]

  egress_rules = ["all-all"]

  tags = local.tags
}
