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

  release_name     = "ingress-nginx"
  repository_url   = "https://kubernetes.github.io/ingress-nginx"
  chart_name       = "ingress-nginx"
  chart_version    = "4.4.2"
  namespace        = "ingress-nginx"
  create_namespace = true

  values_file = templatefile("values.tmpl", {})
}
