locals {
  environment_name = "ta3leem-staging"

  vpc = {
    cidr = "10.22.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets = ["10.22.1.0/24", "10.22.2.0/24"]
    public_subnets  = ["10.22.101.0/24", "10.22.102.0/24"]
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
        rolearn  = "arn:aws:iam::419068741072:role/AWSReservedSSO_PowerUserAccess_a7f31cbf96e0ffe3"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::419068741072:role/AWSReservedSSO_AdministratorAccess_79f5327d6aae3f06"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/ce2b77c1-200f-40c5-9a18-fd06a0ab3265"
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
    Project         = "Ta3leem"
    Owner           = "Creative DevOps"
  }
}
