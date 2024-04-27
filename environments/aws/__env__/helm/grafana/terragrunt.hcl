include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
  secrets      = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "grafana_datasources" {
  config_path = "../../secret/grafana-datasources"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "grafana"
  repository_url = "https://charts.bitnami.com/bitnami"
  chart_name     = "grafana"
  chart_version  = "7.3.0"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "password"            = local.secrets.grafana.password,
      "grafana_datasources" = dependency.grafana_datasources.outputs.name
    }
  )
}
