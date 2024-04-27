include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("uma-staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "../../../../../../../modules/aws/iam-instance-profile///"
}

inputs = {
  name = "KarpenterNodeInstanceProfile-${local.cluster_name}"
  role = dependency.eks.outputs.eks.worker_iam_role_name
}
