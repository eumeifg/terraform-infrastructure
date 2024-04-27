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

dependency "s3" {
  config_path = "../../../_global/s3/chart-repo/"
}

dependency "irsa" {
  config_path = "../../irsa/chartmuseum/"
}

dependency "secret" {
  config_path = "../../secret/chartmuseum/"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "chartmuseum"
  repository_url = "https://chartmuseum.github.io/charts/"
  chart_name     = "chartmuseum"
  chart_version  = "3.1.0"
  namespace      = "chartmuseum"

  values_file = templatefile("values.tmpl",
    {
      "bucket_name"       = dependency.s3.outputs.s3_bucket_id,
      "bucket_region"     = dependency.s3.outputs.s3_bucket_region,
      "role_arn"          = dependency.irsa.outputs.roles.chartmuseum.iam_role_arn,
      "public_key_secret" = dependency.secret.outputs.name
    }
  )
}
