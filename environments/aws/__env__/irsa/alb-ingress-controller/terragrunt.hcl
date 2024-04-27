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
  config_path = "../../eks"
}

terraform {
  source = "../../../../../../modules/aws/irsa///"
}

inputs = {
  cluster_id = dependency.eks.outputs.eks.cluster_id

  cluster_oidc_issuer_url = dependency.eks.outputs.eks.cluster_oidc_issuer_url

  iam_assumable_roles_with_oidc_and_policies = {

    aws-alb-controller = {
      role_name = "aws-alb-controller-${dependency.eks.outputs.eks.cluster_id}"

      oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]

      iam_policy = {
        name   = "aws-alb-controller-${dependency.eks.outputs.eks.cluster_id}"
        policy = file("policies/iam-policy.json")
      }
    }
  }

  tags = local.tags
}
