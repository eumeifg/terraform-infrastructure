locals {
  environment_name = "tamata-staging"

  vpc = {
    cidr = "10.24.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets  = ["10.24.1.0/24", "10.24.2.0/24"]
    public_subnets   = ["10.24.101.0/24", "10.24.102.0/24"]
    database_subnets = ["10.24.6.0/24", "10.24.7.0/24"]
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
        rolearn  = "arn:aws:iam::986679183949:role/AWSReservedSSO_AdministratorAccess_9f4637af71986d93"
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::986679183949:role/AWSReservedSSO_PowerUserAccess_5eaabb19d082e4b4"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::986679183949:role/Rackspace"
        username = "view"
        groups   = ["support:viewer"]
      }
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/b64ea569-7cb3-4954-906c-2fadb48c2fba"
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
    Project         = "TAMATA"
    Owner           = "Creative DevOps"
  }
}
