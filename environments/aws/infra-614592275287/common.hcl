locals {
  environment_name = "creative-advtech-infra"

  vpc = {
    cidr = "10.11.0.0/16"

    azs = [
      "eu-central-1a",
      "eu-central-1b",
    ]

    private_subnets =   ["10.11.1.0/24", "10.11.2.0/24" ]
    public_subnets  =   ["10.11.101.0/24", "10.11.102.0/24" ]
    database_subnets =  ["10.11.3.0/24", "10.11.4.0/24" ]
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
        rolearn  = "arn:aws:iam::614592275287:role/AWSReservedSSO_AdministratorAccess_34132533677d06fe"
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::614592275287:role/AWSReservedSSO_PowerUserAccess_7f2c740d89516a90"
        username = "developer"
        groups   = ["developers"]
      }
    ]

    map_users = [
      {
        userarn  = "arn:aws:iam::614592275287:root"
        username = "root-user"
        groups   = ["system:masters"]
      },
    ]
  }

  kube_prometheus = {
    alertmanager = {
      healthchecks_io_url = "https://hc-ping.com/16c8a693-978e-47f7-b7fd-c229b772ee65"
    }
  }

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform   = "true"
    Environment = local.environment_name
    Owner       = "Creative DevOps"
  }
}
