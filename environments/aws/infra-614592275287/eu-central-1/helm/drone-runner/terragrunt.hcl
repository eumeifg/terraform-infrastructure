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

dependency "irsa" {
  config_path = "../../irsa/drone-runner/"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "drone-runner-kube"
  repository_url = "https://charts.drone.io"
  chart_name     = "drone-runner-kube"
  chart_version  = "0.1.5"
  namespace      = "drone"

  values_file = templatefile("values.tmpl",
    {
      "role_arn"                  = dependency.irsa.outputs.roles.drone-runner.iam_role_arn,
      "drone_secret_plugin_token" = local.secrets.env.DRONE_SECRET_PLUGIN_TOKEN,
      "drone_rpc_secret"          = local.secrets.env.DRONE_RPC_SECRET
    }
  )
}
