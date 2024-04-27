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

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name = "webex-receiver"
  chart_name   = "${get_parent_terragrunt_dir()}/aws/__env__/helm/prometheus-webexteams/alertmanager-webex/"
  namespace    = "monitoring"

  values_file = templatefile("values.tmpl",
    {
      "webex_room"  = local.secrets.webex_room,
      "webex_token" = local.secrets.webex_token
    }
  )
}