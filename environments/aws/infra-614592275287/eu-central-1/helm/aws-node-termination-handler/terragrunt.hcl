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

dependency "eks" {
  config_path = "../../eks"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "aws-node-termination-handler"
  repository_url = "https://aws.github.io/eks-charts"
  chart_name     = "aws-node-termination-handler"
  chart_version  = "0.18.1"
  namespace      = "karpenter"

  values_file = templatefile("values.tmpl",
    {
    }
  )
}
