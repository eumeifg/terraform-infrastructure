locals {
  environment_name = "eschool"

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform       = "true"
    Environment     = "common"
    EnvironmentName = local.environment_name
    Project         = "eschool"
    Owner           = "Creative DevOps"
  }
}
