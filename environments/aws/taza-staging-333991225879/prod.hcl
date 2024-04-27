locals {
  environment_name = "taza-prod"

  vpc = {
    cidr = "10.24.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
      "eu-central-1c",
    ]

    private_subnets  = ["10.24.0.0/20", "10.24.64.0/20", "10.24.128.0/20"]
    public_subnets   = ["10.24.16.0/22", "10.24.80.0/22", "10.24.144.0/22"]
    database_subnets = ["10.24.20.0/24", "10.24.84.0/24", "10.24.148.0/24"]
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
        rolearn  = "arn:aws:iam::333991225879:role/AWSReservedSSO_PowerUserAccess_60278b5b0760758c"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::333991225879:role/AWSReservedSSO_AdministratorAccess_c279862213f9edb9"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/a12980d2-2c87-480e-b2eb-70aa1bdfff71"
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
    Project         = "TAZA"
    Owner           = "Creative DevOps"
  }
}
