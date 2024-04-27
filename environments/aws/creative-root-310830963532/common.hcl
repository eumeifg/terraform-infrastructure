locals {
  environment_name = "creative-advtech-root"

  common_parameters = {}

  common_tags = {
    Terraform   = "true"
    Environment = local.environment_name
    Owner       = "Creative DevOps"
  }
}
