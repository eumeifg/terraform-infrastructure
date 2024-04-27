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

  name        = "${local.environment}-allow-http-and-https-from-365"
  description = "Allow http and https from Microsoft 365 Common and Office Online"
  vpc_id      = dependency.vpc.outputs.vpc_id
  ingress_cidr_blocks = [
    "13.107.6.171/32",
    "13.107.18.15/32",
    "13.107.140.6/32",
    "52.108.0.0/14",
    "52.244.37.168/32",
    "20.20.32.0/19",
    "20.190.128.0/18",
    "20.231.128.0/19",
    "40.126.0.0/18",
    "13.107.6.192/32",
    "13.107.9.192/32",
  ]
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["all-all"]

  tags = local.tags
}
