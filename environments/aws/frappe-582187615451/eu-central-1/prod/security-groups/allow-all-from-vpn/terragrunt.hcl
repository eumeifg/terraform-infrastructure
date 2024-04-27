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
      description = "whitelisting Aziz personal VPN"
      cidr_blocks = "82.165.106.25/32"
    },
    {
      rule        = "all-all"
      description = "whitelisting Dubai Office "
      cidr_blocks = "91.74.45.239/32"
    },
    {
      rule        = "https-443-tcp"
      description = "whitelist Ali Luay IP"
      cidr_blocks = "65.20.152.94/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "3.64.225.88/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "52.59.126.106/32"
    },
    {
      rule        = "all-all"
      description = "whitelist NLB IPS "
      cidr_blocks = "18.153.7.129/32"
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
