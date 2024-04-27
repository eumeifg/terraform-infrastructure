include {
  path = find_in_parent_folders()
}

locals {
  base_qa_instance_vars = read_terragrunt_config(find_in_parent_folders("common/qa-instance/qa-instance.hcl"))
}

dependency "vpc" {
  config_path = "../../vpc/"
}

dependency "key_pair" {
  config_path = "../../key_pair/"
}

dependency "security_group" {
  config_path = "../../security-groups/allow-rdp-from-anywhere/"
}

terraform {
  source = "../../../../../../modules/aws/ec2///"
}

inputs = merge(
  local.base_qa_instance_vars.inputs,
  {
    name = "windows-qa-2"

    key_name = dependency.key_pair.outputs.key_pair_key_name

    vpc_security_group_ids = [dependency.security_group.outputs.security_group_id]
    subnet_id              = dependency.vpc.outputs.public_subnets[0]
  }
)
