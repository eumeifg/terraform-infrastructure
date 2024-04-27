include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks/"
}

dependency "karpenter_irsa" {
  config_path = "../../irsa/karpenter/"
}

dependency "aws_iam_instance_profile" {
  config_path = "../../instance-profile/eks/"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "karpenter"
  repository_url = "https://charts.karpenter.sh"
  chart_name     = "karpenter"
  chart_version  = "0.16.3"
  namespace      = "karpenter"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name"                 = local.cluster_name,
      "service_account"              = dependency.karpenter_irsa.outputs.roles.karpenter.iam_role_arn,
      "cluster_endpoint"             = dependency.eks.outputs.eks.cluster_endpoint,
      "aws_default_instance_profile" = dependency.aws_iam_instance_profile.outputs.name
    }
  )
}
