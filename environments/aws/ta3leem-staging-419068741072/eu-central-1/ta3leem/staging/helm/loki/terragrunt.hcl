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
  source = "../../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "loki"
  repository_url = "https://grafana.github.io/helm-charts"
  chart_name     = "loki"
  chart_version  = "2.10.3"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
    }
  )
}
