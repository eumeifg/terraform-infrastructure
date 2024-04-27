locals {
  environment_name = "frappe-prod"

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
        rolearn  = "arn:aws:iam::582187615451:role/AWSReservedSSO_AdministratorAccess_339498eb4ec85e7e"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/cfcb9f73-74b0-4809-8e65-9849328a2bae"
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
    Project         = "Frappe"
    Owner           = "Creative DevOps"
  }
}
