include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "eks" {
  config_path = "../../../../ta3leem-staging-419068741072/eu-central-1/uma/staging/eks"
}

terraform {
  source = "../../../../../../modules/aws/oidc///"
}

inputs = {
  identity_provider_url = dependency.eks.outputs.eks.cluster_oidc_issuer_url
  client_ids            = ["sts.amazonaws.com"]
  thumbprint_list       = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]

  tags = local.tags
}
