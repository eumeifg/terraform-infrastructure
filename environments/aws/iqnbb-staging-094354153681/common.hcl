locals {
  environment_name = "iqnbb-staging"

  vpc = {
    cidr = "10.21.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets = ["10.21.1.0/24", "10.21.2.0/24"]
    public_subnets  = ["10.21.101.0/24", "10.21.102.0/24"]
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
        rolearn  = "arn:aws:iam::094354153681:role/AWSReservedSSO_PowerUserAccess_c3bc2932428e5c33"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::094354153681:role/AWSReservedSSO_AdministratorAccess_b0b3baec56ee94f0"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/8bcc436a-4886-415f-8947-2b434aca7634"
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
    Project         = "IQNBB"
    Owner           = "Creative DevOps"
  }
}
