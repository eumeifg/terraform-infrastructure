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

  release_name     = "cert-manager"
  repository_url   = "https://charts.jetstack.io"
  chart_name       = "cert-manager"
  chart_version    = "1.11.0"
  namespace        = "cert-manager"
  create_namespace = true

  values_file = templatefile("values.tmpl", {})
}
