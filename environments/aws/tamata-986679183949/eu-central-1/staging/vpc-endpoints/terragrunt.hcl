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
  config_path = "../vpc"
}

dependency "vpc-tls-sg" {
  config_path = "../vpc-tls-SG/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git//modules/vpc-endpoints?ref=v3.11.3"
}

# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest/submodules/vpc-endpoints
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = dependency.vpc.outputs.private_route_table_ids
      tags            = { Name = "s3-vpc-endpoint" }
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.vpc-tls-sg.outputs.security_group_id]
      tags                = { Name = "EC2-vpc-endpoint" }
    },
  }

  tags = local.tags
}
