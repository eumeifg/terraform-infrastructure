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

  name        = "${local.environment}-allow-http-and-https-from-nat-gateway"
  description = "Allow http and https from NAT Gateway public addresses"
  vpc_id      = dependency.vpc.outputs.vpc_id
  #FRAPPE prod and staging  nat gateways: "18.158.32.42/32", "18.197.90.24/32", "3.120.88.112/32", "3.65.91.100/32", "3.74.53.216/32", "3.76.71.238/32"
  ingress_cidr_blocks = [
    "18.158.32.42/32",
    "18.197.90.24/32",
    "3.120.88.112/32",
    "3.65.91.100/32",
    "3.74.53.216/32",
    "3.76.71.238/32",
    "18.196.141.96/32",
    "18.195.57.75/32"
  ]
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["all-all"]

  tags = local.tags
}
