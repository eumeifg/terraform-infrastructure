include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  description = "KMS key for encrypting HELM charts value files"
}

terraform {
  source = "../../../../../modules/aws/kms///"
}

inputs = {
  alias_name = "alias/helm-chart-key"

  description = local.description

  deletion_window_in_days = 30

  tags = merge(
    local.tags,
    {
      Description = local.description
    }
  )
}
