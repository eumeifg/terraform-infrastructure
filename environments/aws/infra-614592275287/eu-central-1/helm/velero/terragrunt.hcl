include {
  path = find_in_parent_folders()
}

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params       = local.common_vars.locals.common_parameters
  environment  = local.common_vars.locals.environment_name
  tags         = local.common_vars.locals.common_tags
  cluster_name = local.params.cluster_name
}

dependency "s3" {
  config_path = "../../../_global/s3/infra-backups"
}

dependency "velero" {
  config_path = "../../irsa/velero//"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  release_name   = "velero"
  repository_url = "https://vmware-tanzu.github.io/helm-charts"
  chart_name     = "velero"
  chart_version  = "2.29.4"
  namespace      = "velero"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name" = local.cluster_name,
      "s3_bucket"    = dependency.s3.outputs.s3_bucket_id,
      "region"       = "eu-central-1"
      "role_arn"     = dependency.velero.outputs.roles.velero-serviceaccount.iam_role_arn,
    }
  )
}
