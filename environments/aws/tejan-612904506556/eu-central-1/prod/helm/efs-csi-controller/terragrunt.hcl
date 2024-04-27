include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "irsa_csi" {
  config_path = "../../irsa/efs-csi-controller///"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "aws-efs-csi-drive"
  repository_url = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart_name     = "aws-efs-csi-driver"
  chart_version  = "2.2.7"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl",
    {
      "role_arn" = dependency.irsa_csi.outputs.roles.aws-efs-csi-controller.iam_role_arn,
      "tag"      = "v1.4.0"
    }
  )
}
