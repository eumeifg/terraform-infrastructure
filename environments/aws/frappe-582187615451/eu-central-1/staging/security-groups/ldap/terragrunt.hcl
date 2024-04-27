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
  name        = "${local.environment}-sg-for-ldap"
  description = "Allow RDP connection to ldap app "
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = "ldap access for private-eu-central-1c "
      cidr_blocks = "10.26.128.0/20"
    },
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = "ldap access for private-eu-central-1a"
      cidr_blocks = "10.26.0.0/20"
    },
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = "ldap access for private-eu-central-1b"
      cidr_blocks = "10.26.64.0/20"
    },
  ]

  egress_rules = ["all-all"]
  tags         = local.tags
}
