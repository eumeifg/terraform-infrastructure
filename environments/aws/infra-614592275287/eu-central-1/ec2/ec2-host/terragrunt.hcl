include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "../../../../../../modules/aws/ec2-host///"
}

inputs = {

  name = "${local.environment}-macos-ec2-host"

  instance_type     = "mac1.metal"
  availability_zone = "eu-central-1a"
  auto_placement    = "on"

  tags = local.tags
}
