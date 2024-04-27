include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "irsa" {
  config_path = "../../../../../creative-root-310830963532/_global/irsa/external-dns-eschool-staging/"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "external-dns"
  repository_url = "https://kubernetes-sigs.github.io/external-dns"
  chart_name     = "external-dns"
  chart_version  = "1.12.2"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl",
    {
      "role_arn"   = dependency.irsa.outputs.roles.external-dns.iam_role_arn,
      "txt_owner_id" = local.cluster_name
    }
  )
}
