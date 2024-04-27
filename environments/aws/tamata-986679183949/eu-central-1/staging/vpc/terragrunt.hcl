include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git///?ref=v3.11.3"
}

# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=inputs
inputs = {
  name = local.environment

  cidr = local.common_vars.locals.vpc.cidr

  azs = local.common_vars.locals.vpc.azs

  private_subnets  = local.common_vars.locals.vpc.private_subnets
  public_subnets   = local.common_vars.locals.vpc.public_subnets
  database_subnets = local.common_vars.locals.vpc.database_subnets

  map_public_ip_on_launch = true

  enable_nat_gateway = true

  enable_dns_hostnames = true

  create_database_subnet_group           = true
  create_database_subnet_route_table     = false
  create_database_nat_gateway_route      = false
  create_database_internet_gateway_route = false

  # Additional tags for the public subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.params.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                             = "1"
  }

  # Additional tags for the private subnets
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.params.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                    = "1"
    "karpenter.sh/discovery"                             = local.params.cluster_name
  }

  tags = local.tags
}
