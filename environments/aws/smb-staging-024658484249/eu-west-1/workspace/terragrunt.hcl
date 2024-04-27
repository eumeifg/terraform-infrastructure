include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  description = "AWS Workspace instance to run Visual Studio C++"
}

terraform {
  source = "../../../../../modules/aws/workspace///"
}

inputs = {
  tags = merge(
    local.tags,
    {
      Description = local.description
    }
  )
}
