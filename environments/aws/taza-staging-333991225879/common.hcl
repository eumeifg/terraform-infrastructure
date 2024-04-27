locals {
  environment_name = "taza-staging"

  vpc = {
    cidr = "10.23.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets = ["10.23.1.0/24", "10.23.2.0/24"]
    public_subnets  = ["10.23.101.0/24", "10.23.102.0/24"]
  }

  eks = {
    kubeconfig_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"

    # TODO: create dedicated service accounts. Don't use system:masters
    map_roles = [
      {
        rolearn  = "arn:aws:iam::310830963532:role/DevOps"
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::333991225879:role/AWSReservedSSO_PowerUserAccess_60278b5b0760758c"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::333991225879:role/AWSReservedSSO_AdministratorAccess_c279862213f9edb9"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/2a022118-7f25-4609-83c9-2731dbbba64f"
    }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    Environment     = "staging"
    EnvironmentName = local.environment_name
    Project         = "TAZA"
    Owner           = "Creative DevOps"
  }
}
