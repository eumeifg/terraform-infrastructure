include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "iam-user" {
  config_path = "../../iam-users/frappe/"
}

dependency "iam-policy" {
  config_path = "../../iam-policy/frappe/"
}

terraform {
  source = "../../../../../../../modules/aws/iam/iam-user-policy-attachment///"
}

inputs = {
  iam_user_name = dependency.iam-user.outputs.iam_user_name
  policy_arn    = dependency.iam-policy.outputs.arn
}
