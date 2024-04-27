locals {
  environment_name = "clients-staging"

  common_parameters = {
    cluster_name           = "eks-${local.environment_name}"
    eks_admin_iam_role_arn = "arn:aws:iam::310830963532:role/DevOps"
  }

  common_tags = {
    Terraform = "true"
    Project   = "clients"
    Owner     = "Creative DevOps"
  }
}
