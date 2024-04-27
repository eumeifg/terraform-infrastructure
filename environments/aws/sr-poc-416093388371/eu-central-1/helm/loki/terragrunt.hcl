include {
  path = find_in_parent_folders()
}

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params       = local.common_vars.locals.common_parameters
  environment  = local.common_vars.locals.environment_name
  tags         = local.common_vars.locals.common_tags
  cluster_name = local.params.cluster_name
  secrets      = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "loki" {
  config_path = "../../irsa/loki/"
}



terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "loki"
  repository_url = "https://charts.bitnami.com/bitnami"
  chart_name     = "grafana-loki"
  chart_version  = "2.7.1"
  namespace      = "loki"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name"        = local.cluster_name,
      "loki_role"           = dependency.loki.outputs.roles.loki.iam_role_arn,
      "gatewayAuthPassword" = local.secrets.gateway.auth.password
    }
  )
}
