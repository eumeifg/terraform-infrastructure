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

  release_name   = "kube-prometheus-stack"
  repository_url = "https://charts.bitnami.com/bitnami"
  chart_name     = "kube-prometheus"
  chart_version  = "6.1.8"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "healthchecks_io_url" = local.common_vars.locals.kube_prometheus.alertmanager.healthchecks_io_url,
      "cluster_name"        = local.cluster_name
    }
  )
}
