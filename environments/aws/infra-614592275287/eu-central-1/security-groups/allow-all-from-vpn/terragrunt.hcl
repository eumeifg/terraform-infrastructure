include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "vpn" {
  config_path = "../../ec2/vpn-enterprise"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.16.2"
}

inputs = {

  name        = "${local.environment}-allow-all-from-vpn"
  description = "Allow all from VPN"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = dependency.vpn.outputs.main_security_group_id
    },
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "whitelisting Infra enterprice VPN Server"
      cidr_blocks = "18.195.73.226/32"
    },
    {
      rule        = "all-all"
      description = "whitelisting A. Zaki personal IP"
      cidr_blocks = "156.174.176.40/32"
    },
    {
      rule        = "all-all"
      description = "whitelisting Aziz personal VPN"
      cidr_blocks = "82.165.106.25/32"
    },
    {
      rule        = "https-443-tcp"
      description = "H"
      cidr_blocks = "169.224.9.37/32"
    },
    {
      rule        = "all-all"
      description = "whitelist Squid"
      cidr_blocks = "138.68.101.200/32"
    },
    {
      rule        = "all-all"
      description = ""
      cidr_blocks = "52.28.170.65/32"
    }
  ]

  egress_rules        = ["all-all"]

  tags = local.tags
}
