include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
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

  name        = "${local.environment}-allow-all-from-vpn-and-Dubai-Office"
  description = "Allow all from VPN and Dubai Office"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "whitelisting Infra enterprice  VPN Server"
      cidr_blocks = "18.195.73.226/32"
    },
    {
      rule        = "all-all"
      description = "whitelisting Infra VPN Server"
      cidr_blocks = "3.125.197.144/32"
    },
    {
      rule        = "all-all"
      description = "whitelisting Dubai Office "
      cidr_blocks = "91.74.45.239/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "3.64.242.163/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "3.78.43.223/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "54.93.180.85/32"
    },
    {
      rule        = "all-all"
      description = "frappe VPN SERVER "
      cidr_blocks = "3.77.176.138/32"
    }

  ]

  egress_rules = ["all-all"]

  tags = local.tags
}
