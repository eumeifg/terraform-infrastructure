locals {
  environment_name = "eschool-staging"

  vpc = {
    cidr = "10.10.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
      "eu-central-1c",
    ]

    private_subnets  = ["10.10.0.0/20", "10.10.64.0/20", "10.10.128.0/20"]
    public_subnets   = ["10.10.16.0/22", "10.10.80.0/22", "10.10.144.0/22"]
    database_subnets = ["10.10.20.0/24", "10.10.84.0/24", "10.10.148.0/24"]
  }

  eks = {
    kubeconfig_admin_iam_role_arn = "arn:aws:iam::333810858387:role/DevOps"

    # TODO: create dedicated service accounts. Don't use system:masters
    map_roles = [
      {
        rolearn  = "arn:aws:iam::310830963532:role/DevOps"
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::333810858387:role/AWSReservedSSO_PowerUserAccess_cd3ecfae9dcd69dd"
        username = "developer"
        groups   = ["developers"]
      },
      {
        rolearn  = "arn:aws:iam::333810858387:role/AWSReservedSSO_AdministratorAccess_d6812fea96b1511b"
        username = "admin"
        groups   = ["system:masters"]
      },
    ]
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    Environment     = "staging"
    EnvironmentName = local.environment_name
    Project         = "eschool"
    Owner           = "Creative DevOps"
  }
}
