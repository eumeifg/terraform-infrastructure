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

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy?ref=v4.18.0"
}

inputs = {
  name        = "${local.cluster_name}-ses-policy"
  path        = "/"
  description = "Ses policy"

  policy = file("policies/ses-policy.json")
}
