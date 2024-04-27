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

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.17.1"
}

inputs = {

  name        = "${local.environment}-allow-rdp-from-anywhere"
  description = "Allow RDP from anywhere."
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules = ["rdp-tcp"]
  egress_rules  = ["all-all"]

  tags = local.tags
}
