include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
  # secrets = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "eks" {
  config_path = "../../eks"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "blackbox-exporter"
  repository_url = "https://prometheus-community.github.io/helm-charts"
  chart_name     = "prometheus-blackbox-exporter"
  chart_version  = "5.3.2"
  namespace      = "monitoring"

  values_file = templatefile("values.tmpl",
    {
    }
  )
}
