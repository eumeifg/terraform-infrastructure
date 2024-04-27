include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../../vpc/"
}

dependency "key_pair" {
  config_path = "../../key_pair/"
}

dependency "security_group" {
  config_path = "../../security-groups/allow-all-from-vpn/"
}

terraform {
  source = "../../../../../../modules/aws/ec2///"
}

inputs = {

  create_spot_instance   = true
  name = "${local.environment}-saman-jasim-workload"
  ami                    = "ami-03e08697c325f02ab"
  instance_type          = "t3.small"
  key_name               = dependency.key_pair.outputs.key_pair_key_name
  monitoring             = true
  vpc_security_group_ids = [dependency.security_group.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.private_subnets[1]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 100
    },
  ]

  tags = local.tags
}
