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

  release_name   = "nvidia-device-plugin"
  repository_url = "https://nvidia.github.io/k8s-device-plugin"
  chart_name     = "nvidia-device-plugin"
  chart_version  = "0.10.0"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl", {})
}
