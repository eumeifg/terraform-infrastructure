include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  tags        = local.common_vars.locals.common_tags
}

dependency "kms" {
  config_path = "../../../eu-central-1/kms"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v2.14.1"
}

inputs = {
  bucket = "ta3-helm-repo"

  versioning = {
    enabled = false
  }

  tags = local.tags
}
