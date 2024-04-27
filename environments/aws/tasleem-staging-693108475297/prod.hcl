locals {
  environment_name = "tasleem-prod"

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
      healthchecks_io_url = "https://hc-ping.com/fbdd7cef-36be-47eb-81a5-856f733590b2"
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
    Project         = "Tasleem"
    Owner           = "Creative DevOps"
  }
}
