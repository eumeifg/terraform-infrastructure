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

  name        = "${local.environment}-allow-https-from-bitbucket"
  description = "Allow https from Bitbucket public addresses."
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks = [
    "13.52.5.96/28",
    "13.236.8.224/28",
    "18.136.214.96/28",
    "18.184.99.224/28",
    "18.234.32.224/28",
    "18.246.31.224/28",
    "52.215.192.224/28",
    "104.192.137.240/28",
    "104.192.138.240/28",
    "104.192.140.240/28",
    "104.192.142.240/28",
    "104.192.143.240/28",
    "185.166.143.240/28",
    "185.166.142.240/28",
  ]
  ingress_rules = ["https-443-tcp"]
  egress_rules  = ["all-all"]

  tags = local.tags
}
