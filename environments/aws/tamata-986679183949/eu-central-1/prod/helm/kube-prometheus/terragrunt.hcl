include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name      = local.params.cluster_name
  secrets           = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
  webex_webhook_url = "http://webex-receiver.monitoring.svc.cluster.local:9091/alertmanager"
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
  chart_version  = "43.3.1"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "healthchecks_io_url" = local.common_vars.locals.kube_prometheus.alertmanager.healthchecks_io_url,
      "webex_webhook_url"   = local.webex_webhook_url,
      "cluster_name"        = local.cluster_name,
      "opsgenie_api_key"    = local.secrets.opsgenie.apiKey,
      "grafana_role"        = dependency.grafana.outputs.roles.grafana.iam_role_arn,
      "client_id"           = local.secrets.client_id,
      "client_secret"       = local.secrets.client_secret
    }
  )
}
