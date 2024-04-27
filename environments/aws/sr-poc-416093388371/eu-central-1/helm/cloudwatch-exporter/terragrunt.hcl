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
  config_path = "../../eks/"
}

dependency "cloudwatch-exporter" {
  config_path = "../../irsa/cloudwatch-exporter/"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "cloudwatch-exporter"
  repository_url = "https://prometheus-community.github.io/helm-charts"
  chart_name     = "prometheus-cloudwatch-exporter"
  chart_version  = "0.22.0"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "role_arn" = dependency.cloudwatch-exporter.outputs.roles.cloudwatch-exporter.iam_role_arn,
    }
  )
}
