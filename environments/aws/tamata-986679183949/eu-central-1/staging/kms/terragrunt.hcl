include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  description = "KMS key for encrypting EKS Secrets for ${local.params.cluster_name} cluster"
}

terraform {
  source = "../../../../../../modules/aws/kms///"
}

inputs = {
  alias_name = "alias/kms-${local.params.cluster_name}"

  description = local.description

  deletion_window_in_days = 30

  tags = merge(
    local.tags,
    {
      Description = local.description
    }
  )
}
