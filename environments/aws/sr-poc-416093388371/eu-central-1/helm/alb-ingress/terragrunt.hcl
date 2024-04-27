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

# EKS IRSA IAM Roles
dependency "alb_ingress" {
  config_path = "../../irsa/alb-ingress-controller///"
}

terraform {
  source = "../../../../../../modules/k8s/helm///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  release_name   = "aws-load-balancer-controller"
  repository_url = "https://aws.github.io/eks-charts"
  chart_name     = "aws-load-balancer-controller"
  chart_version  = "1.4.2"
  namespace      = "kube-system"

  values_file = templatefile("values.tmpl",
    {
      "cluster_name" = local.cluster_name,
      "role_arn"     = dependency.alb_ingress.outputs.roles.aws-alb-controller.iam_role_arn,
    }
  )
}
