include {
  path = find_in_parent_folders()
}

locals {
  base_ecr_vars = read_terragrunt_config(find_in_parent_folders("common/ecr/ecr.hcl"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/ecr///"
}

inputs = merge(
  local.base_ecr_vars.inputs,
  {
    name = "ta3leem-transcode-node"
  }
)
