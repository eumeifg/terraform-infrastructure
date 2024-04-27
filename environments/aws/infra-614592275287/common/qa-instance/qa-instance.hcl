locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

inputs = {
  ami           = "ami-0cf9380844da84d7e"
  instance_type = "m5a.xlarge"

  associate_public_ip_address = true

  instance_initiated_shutdown_behavior = "stop"

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 50
    },
  ]

  tags = local.tags
}
