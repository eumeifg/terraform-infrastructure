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
  config_path = "../../security-groups/macos/"
}

dependency "ec2_host" {
  config_path = "../ec2-host/"
}

terraform {
  source = "../../../../../../modules/aws/m1-macos///"
}

inputs = {

  name = "${local.environment}-macos-m1-01"

  custom_ami             = "ami-0db9238c33c33525b"
  key_name               = dependency.key_pair.outputs.key_pair_key_name
  availability_zone      = "eu-central-1a"
  dedicated_host_id      = dependency.ec2_host.outputs.ec2_host_id
  vpc_security_group_ids = [dependency.security_group.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.private_subnets[0]

  tags = local.tags
}
