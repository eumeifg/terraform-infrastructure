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

# EKS IRSA IAM Roles
dependency "irsa" {
  config_path = "../../irsa/aws-load-balancer-controller//"
}

terraform {
  source = "../../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "aws-load-balancer-controller"
  repository_url = "https://aws.github.io/eks-charts"
  chart_name     = "aws-load-balancer-controller"
  chart_version  = "1.4.8"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name" = local.cluster_name,
      "role_arn"     = dependency.irsa.outputs.roles.aws-load-balancer-controller.iam_role_arn,
    }
  )
}
