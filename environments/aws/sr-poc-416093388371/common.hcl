locals {
  environment_name = "sr-poc-staging"

  vpc = {
    cidr = "10.30.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets  = ["10.30.1.0/24", "10.30.2.0/24"]
    public_subnets   = ["10.30.101.0/24", "10.30.102.0/24"]
    database_subnets = ["10.30.6.0/24", "10.30.7.0/24"]
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
        rolearn  = "arn:aws:iam::416093388371:role/AWSReservedSSO_PowerUserAccess_f802460740e6e86c"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::416093388371:role/AWSReservedSSO_AdministratorAccess_f7da0996d8aabfc0"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/613d4d64-e47c-40c8-a46c-76429cf8b0cd"
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
    Project         = "sr-poc"
    Owner           = "Creative DevOps"
  }
}
