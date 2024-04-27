include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "eks" {
  config_path = "../../eks/"
}

terraform {
  source = "../../../../../../../modules/aws/irsa///"
}

inputs = {
  cluster_id = dependency.eks.outputs.eks.cluster_id

  cluster_oidc_issuer_url = dependency.eks.outputs.eks.cluster_oidc_issuer_url

  iam_assumable_roles_with_oidc_and_policies = {

    karpenter = {
      role_name = "item-based-recommendation-${dependency.eks.outputs.eks.cluster_id}"

      oidc_fully_qualified_subjects = ["system:serviceaccount:tamata:item-based-recommendation"]

      iam_policy = {
        name   = "item-based-recommendation-${dependency.eks.outputs.eks.cluster_id}"
        policy = file("policies/policy.json")
      }
    }
  }

  tags = local.tags
}
