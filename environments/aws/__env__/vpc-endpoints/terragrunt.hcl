include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../../../modules/aws/s3-gateway-endpoint///"
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  route_table_ids = dependency.vpc.outputs.private_route_table_ids
  region          = "eu-central-1"

  policy = jsonencode({
    "Version" = "2008-10-17"
    "Statement" : [
      {
        "Action" : "*",
        "Effect" : "Allow",
        "Resource" : "*",
        "Principal" : "*"
      }
    ]
  })

  tags = local.tags
}
