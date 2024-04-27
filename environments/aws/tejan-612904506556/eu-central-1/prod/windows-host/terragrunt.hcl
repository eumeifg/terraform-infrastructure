include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependencies {
  paths = ["../vpc", "../key_pair", "../windows-host-SG/"]
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "key_pair" {
  config_path = "../key_pair/"
}

dependency "security_group" {
  config_path = "../windows-host-SG/"
}

terraform {
  source = "../../../../../../modules/aws/ec2///"
}

inputs = {

  name = "${local.environment}"

  ami                    = "ami-0e819b6e6e41b30a7"
  instance_type          = "m5a.2xlarge"
  key_name               = dependency.key_pair.outputs.key_pair_key_name
  monitoring             = true
  vpc_security_group_ids = [dependency.security_group.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.public_subnets[1]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 1000
    },
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }

  tags = local.tags
}
