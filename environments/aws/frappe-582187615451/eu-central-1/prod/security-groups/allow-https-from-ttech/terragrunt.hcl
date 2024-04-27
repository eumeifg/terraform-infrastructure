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

  name        = "${local.environment}-allow-https-from-Ttech "
  description = "Allow https from Ttech  Offices  "
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "whitelisting from Ttech  Offices"
      cidr_blocks = "37.237.139.215/32"
    },
    {
      rule        = "https-443-tcp"
      description = "whitelisting from in Earthlink HQ4"
      cidr_blocks = "37.239.255.249/32"
    }

  ]

  egress_rules = ["all-all"]

  tags = local.tags
}
