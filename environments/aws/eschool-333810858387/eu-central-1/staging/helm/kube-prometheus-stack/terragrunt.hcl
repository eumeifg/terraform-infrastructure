include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name      = local.params.cluster_name
  secrets           = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "grafana" {
  config_path = "../../irsa/grafana/"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "kube-prometheus-stack"
  repository_url = "https://prometheus-community.github.io/helm-charts"
  chart_name     = "kube-prometheus-stack"
  chart_version  = "45.x.x"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name"           = local.cluster_name,
      "grafana_role"           = dependency.grafana.outputs.roles.grafana.iam_role_arn,
      "grafana_admin_password" = local.secrets.grafana.adminPassword,
      "client_id"              = local.secrets.client_id,
      "client_secret"          = local.secrets.client_secret
    }
  )
}
