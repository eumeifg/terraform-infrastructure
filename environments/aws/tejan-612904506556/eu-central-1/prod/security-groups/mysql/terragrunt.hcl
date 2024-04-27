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
  config_path = "../../vpc/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.8.0"
}

inputs = {
  name = "${local.environment}-allow-mysql"

  vpc_id = dependency.vpc.outputs.vpc_id

  egress_rules        = ["all-all"]
  ingress_rules       = ["mysql-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow MySQL Private Subnet"
      cidr_blocks = "10.28.1.0/24"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow MySQL Private Subnet"
      cidr_blocks = "10.28.2.0/24"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow MySQL Public tableau  Server"
      cidr_blocks = "10.28.16.0/24"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow MySQL Public Subnet For tableau  Server"
      cidr_blocks = "10.28.80.0/22"
    }
  ]
  description = "Allow MySQL inbound traffic"

  tags = local.tags
}
