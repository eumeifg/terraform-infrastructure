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

  name        = "${local.environment}-allow-http-and-https-from-nat-gateway"
  description = "Allow http and https from NAT Gateway public addresses."
  vpc_id      = dependency.vpc.outputs.vpc_id

  #IP addresses of NAT Gateways for various AWS accounts
  #Infra account "18.196.141.96/32", "18.195.57.75/32"
  #Tamata staging account: "52.28.170.65/32", "3.69.41.14/32"
  #Taza staging account: "3.70.7.53"
  #Ta3leem staging account: "52.58.128.223/32", "3.69.129.157/32"
  #Ta3leem bastion host: "37.238.253.68/32"
  #SMB nat gateways: "52.58.76.69/32", "18.192.201.220/32"
  #FRAPPE prod and staging  nat gateways: "18.158.32.42/32", "18.197.90.24/32", "3.120.88.112/32", "3.65.91.100/32", "3.74.53.216/32", "3.76.71.238/32"
  # Clinets staging Nat Gateways: "18.184.109.108/32", "18.158.218.134/32"
  # Tejan Nat Gateways: "18.192.168.72", "3.123.91.10"
  # Eschool Nat Gateways: "3.122.33.200/32"
  # Social Reputation Nat Gateways: "3.123.194.14/32", "3.64.113.151/32"
  # Uma staging: "18.195.42.201/32", "35.157.161.218/32"
  # Tasleem staging: "3.127.26.73/32", "3.123.96.19/32"
  ingress_cidr_blocks = [
    "18.195.42.201/32",
    "35.157.161.218/32",
    "3.123.96.19/32",
    "3.127.26.73/32",
    "18.196.141.96/32",
    "18.195.57.75/32",
    "52.28.170.65/32",
    "3.69.41.14/32",
    "37.238.253.68/32",
    "3.70.7.53/32",
    "52.58.128.223/32",
    "3.69.129.157/32",
    "52.58.76.69/32",
    "18.192.201.220/32",
    "18.158.32.42/32",
    "18.197.90.24/32",
    "3.120.88.112/32",
    "3.65.91.100/32",
    "3.74.53.216/32",
    "3.76.71.238/32",
    "18.184.109.108/32",
    "18.158.218.134/32",
    "3.123.91.10/32",
    "18.192.168.72/32",
    "3.122.33.200/32",
    "3.123.194.14/32",
    "3.64.113.151/32"
  ]
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["all-all"]

  tags = local.tags
}
