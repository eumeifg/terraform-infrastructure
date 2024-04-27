locals {
  environment_name = "tamata"

  eks = {
    kubeconfig_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"

    # TODO: create dedicated service accounts. Don't use system:masters
    map_roles = [
      {
        rolearn  = "arn:aws:iam::310830963532:role/DevOps"
        username = "admin"
        groups   = ["system:masters"]
      }
    ]
  }

  kube_prometheus = {
    # alertmanager = {
    #   healthchecks_io_url = "https://hc-ping.com/2a022118-7f25-4609-83c9-2731dbbba64f"
    # }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    EnvironmentName = local.environment_name
    Project         = "TAMATA"
    Owner           = "Creative DevOps"
  }
}
