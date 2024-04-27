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

dependency "vpn" {
  config_path = "../../ec2/pritunl"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.9.0"
}

inputs = {
  name        = "${local.environment}-allow-mysql-from-vpn"
  description = "Allow inbound traffic to MySQL port from staging VPN"

  vpc_id = dependency.vpc.outputs.vpc_id

  egress_rules = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = dependency.vpn.outputs.main_security_group_id
    },
  ]

  tags = local.tags
}
