locals {
  environment_name = "clients-staging"

  vpc = {
    cidr = "10.20.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
    public_subnets   = ["10.20.101.0/24", "10.20.102.0/24"]
    database_subnets = ["10.20.6.0/24", "10.20.7.0/24"]
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
        rolearn  = "arn:aws:iam::555195170445:role/AWSReservedSSO_PowerUserAccess_616fe088627a99ed"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::555195170445:role/AWSReservedSSO_AdministratorAccess_5f31325239868042"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/6f52abe4-ea36-4a2c-aa8f-77883057e5db"
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
    Project         = "clients"
    Owner           = "Creative DevOps"
  }
}
