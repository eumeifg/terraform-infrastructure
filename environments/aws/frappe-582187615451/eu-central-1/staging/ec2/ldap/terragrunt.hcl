include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../../vpc/"
}

dependency "security_group" {
  config_path = "../../security-groups/ldap/"
}

terraform {
  source = "../../../../../../../modules/aws/ec2///"
}

inputs = {
  name                   = "${local.environment}-ldap-app"
  ami                    = "ami-0cf9380844da84d7e"
  instance_type          = "t2.micro"
  key_name               = "frappe-key"
  monitoring             = true
  vpc_security_group_ids = [dependency.security_group.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.public_subnets[1]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 30
    },
  ]

  tags = local.tags
}
