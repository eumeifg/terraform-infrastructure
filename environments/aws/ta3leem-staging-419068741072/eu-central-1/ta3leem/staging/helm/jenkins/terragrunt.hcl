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

terraform {
  source = "../../../../../../../../modules/k8s/helm///"
}

inputs = {
  release_name  = "jenkins-rbac"
  chart_name    = "https://ta3-helm-repo.s3.eu-central-1.amazonaws.com/charts/jenkins-rbac-0.1.0.tgz"
  chart_version = "0.1.0"
  namespace     = "infra"
}
