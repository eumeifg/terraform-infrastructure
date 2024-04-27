include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name

}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "kms" {
  config_path = "../kms"
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/efs///"
}

inputs = {
  subnets = dependency.vpc.outputs.private_subnets

  creation_token = "efs-data-${local.params.cluster_name}"
  encrypted  = true
  kms_key_id = dependency.kms.outputs.key_arn
  performance_mode = "generalPurpose"

  security_groups = [dependency.eks.outputs.eks.worker_security_group_id]

  tags = merge(
    local.tags,
    {
      Name        = "efs-data-${local.params.cluster_name}"
      Description = "EFS for ${local.environment}"
    }
  )
}
