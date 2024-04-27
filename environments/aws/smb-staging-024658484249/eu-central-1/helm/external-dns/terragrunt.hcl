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
  config_path = "../../eks"
}

dependency "external_dns_role" {
  config_path = "../../../../creative-root-310830963532/_global/irsa/external-dns-smb-staging/"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name     = "external-dns"
  repository_url   = "https://kubernetes-sigs.github.io/external-dns"
  chart_name       = "external-dns"
  chart_version    = "1.12.0"
  namespace        = "external-dns"
  create_namespace = true

  values_file = templatefile("values.tmpl",
    {
      "role_arn"   = dependency.external_dns_role.outputs.roles.external-dns.iam_role_arn,
      "txtOwnerId" = local.cluster_name
    }
  )
}
