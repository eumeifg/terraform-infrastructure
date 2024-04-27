include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "../../../../../../../modules/aws/lifecycle-manager///"
}

inputs = {

  name            = "${local.environment}-Snapshots-lifecycle"
  environment     = "tejan-prod"
  label_order     = ["name", "environment"]
  resource_types  = ["INSTANCE"]
  interval        = "24"
  interval_unit   = "HOURS"
  times           = ["00:00"]
  count-number    = "10"
  SnapshotCreator = "DLM"
  copy_tags       = true
  target_tags = {

    Snapshots = "True"

  }
}
