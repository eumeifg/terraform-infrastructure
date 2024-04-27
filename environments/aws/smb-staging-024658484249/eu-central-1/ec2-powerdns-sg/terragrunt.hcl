include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git///?ref=v4.7.0"
}

inputs = {
  name = "${local.environment}_allow"

  vpc_id = dependency.vpc.outputs.vpc_id

  egress_rules        = ["all-all"]
  ingress_rules       = ["ssh-tcp", "dns-tcp", "dns-udp", "all-icmp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  // https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest#security-group-with-custom-rules
  ingress_with_cidr_blocks = [
    {
      from_port   = 8081
      to_port     = 8081
      protocol    = 6
      description = "Allow connection to ports 8081"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  description = "Allow inbound traffic"

  tags = local.tags
}
