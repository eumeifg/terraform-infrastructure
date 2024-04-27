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
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "drone-kubernetes-secrets"
  repository_url = "https://charts.drone.io"
  chart_name     = "drone-kubernetes-secrets"
  chart_version  = "0.1.4"
  namespace      = "drone"

  values_file = templatefile("values.tmpl",
    {
      "secret_key" = local.secrets.env.SECRET_KEY
    }
  )
}
