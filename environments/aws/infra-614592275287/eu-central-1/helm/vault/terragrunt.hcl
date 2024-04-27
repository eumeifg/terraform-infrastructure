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

dependency "s3" {
  config_path = "../../../_global/s3/vault-state///"
}

dependency "kms" {
  config_path = "../../kms-for-vault///"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "vault"
  repository_url = "https://helm.releases.hashicorp.com"
  chart_name     = "vault"
  chart_version  = "0.23.0"
  namespace      = "vault"

  values_file = templatefile("values.tmpl",
    {
      "kms"        = dependency.kms.outputs.key_id,
      "buckets"    = dependency.s3.outputs.s3_bucket_id,
      "region"     = dependency.s3.outputs.s3_bucket_region,
      "access_key" = local.secrets.access_key
      "secret_key" = local.secrets.secret_key
    }
  )
}
