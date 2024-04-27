locals {
  environment_name = "uma-staging"

  vpc = {
    cidr = "10.20.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b"
    ]

    private_subnets  = ["10.20.0.0/23", "10.20.2.0/23"]
    public_subnets   = ["10.20.128.0/24", "10.20.129.0/24"]
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
        rolearn  = "arn:aws:iam::419068741072:role/AWSReservedSSO_AdministratorAccess_79f5327d6aae3f06"
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::419068741072:role/AWSReservedSSO_PowerUserAccess_a7f31cbf96e0ffe3"
        username = "developer"
        groups   = ["developers"]
      }
    ]
  }

  kube_prometheus = {
    # alertmanager = {
    #   healthchecks_io_url = "https://hc-ping.com/b64ea569-7cb3-4954-906c-2fadb48c2fba"
    # }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    Environment     = "staging"
    EnvironmentName = local.environment_name
    Project         = "UMA"
    Owner           = "Creative DevOps"
  }
}

