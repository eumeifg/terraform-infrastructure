include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../../../../modules/aws/security-group///"
}

inputs = {

  name        = "${local.environment}-sg"
  description = "Allow RDP connection to Tejan windows host"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 33091
      to_port     = 33091
      protocol    = "tcp"
      description = "Remote Desktop"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Remote Desktop"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "SQL Server To tableau  Server "
      cidr_blocks = "10.28.80.0/22"
    },
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}
