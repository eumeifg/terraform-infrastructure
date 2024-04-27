include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
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

  private_subnets = local.common_vars.locals.vpc.private_subnets
  public_subnets  = local.common_vars.locals.vpc.public_subnets


  enable_nat_gateway = true

  enable_dns_hostnames = true

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
