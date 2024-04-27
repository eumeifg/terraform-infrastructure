locals {
  environment_name = "tejan-prod"

  vpc = {
    cidr = "10.28.0.0/16"

    azs = [
      "eu-central-1b",
      "eu-central-1c",
    ]

    private_subnets  = ["10.28.1.0/24", "10.28.2.0/24"]
    public_subnets   = ["10.28.16.0/24", "10.28.80.0/22"]
    database_subnets = ["10.28.4.0/24", "10.28.5.0/24"]
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
        rolearn  = "arn:aws:iam::612904506556:role/AWSReservedSSO_AdministratorAccess_97340f6cb767d84a"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/8c194618-1046-4158-9940-a64ceed26e8b"
    }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }
  common_tags = {
    Terraform       = "true"
    Environment     = "production"
    EnvironmentName = local.environment_name
    Project         = "Tejan"
    Owner           = "Creative DevOps"
    Snapshots       = "True"
  }
}
