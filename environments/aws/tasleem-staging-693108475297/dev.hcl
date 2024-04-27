locals {
  environment_name = "tasleem-staging"

  vpc = {
    cidr = "10.24.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets = ["10.24.1.0/24", "10.24.2.0/24"]
    public_subnets  = ["10.24.101.0/24", "10.24.102.0/24"]
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
        rolearn  = "arn:aws:iam::693108475297:role/AWSReservedSSO_PowerUserAccess_2cad058f0bc3b470"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::693108475297:role/AWSReservedSSO_AdministratorAccess_c24a03a746efe332"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/b3f0bc89-d1be-4874-b0c7-31f7a9f14d38"
    }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    Environment     = "dev"
    EnvironmentName = local.environment_name
    Project         = "Tasleem"
    Owner           = "Creative DevOps"
  }
}
