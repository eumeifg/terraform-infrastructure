include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "irsa" {
  config_path = "../../irsa/cluster-autoscaler/"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "cluster-autoscaler"
  repository_url = "https://kubernetes.github.io/autoscaler"
  chart_name     = "cluster-autoscaler"
  chart_version  = "9.11.0"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name" = local.cluster_name,
      "role_arn"     = dependency.irsa.outputs.roles.cluster-autoscaler.iam_role_arn
    }
  )
}
