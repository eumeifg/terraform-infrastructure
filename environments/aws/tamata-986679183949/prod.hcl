locals {
  environment_name = "tamata-prod"

  vpc = {
    cidr = "10.25.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
      "eu-central-1c",
    ]

    private_subnets  = ["10.25.0.0/20", "10.25.64.0/20", "10.25.128.0/20"]
    public_subnets   = ["10.25.16.0/22", "10.25.80.0/22", "10.25.144.0/22"]
    database_subnets = ["10.25.20.0/24", "10.25.84.0/24", "10.25.148.0/24"]
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
      healthchecks_io_url = "https://hc-ping.com/86bc44bd-3090-448b-a6b2-a8fc68537d99"
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
    Project         = "TAMATA"
    Owner           = "Creative DevOps"
  }
}
