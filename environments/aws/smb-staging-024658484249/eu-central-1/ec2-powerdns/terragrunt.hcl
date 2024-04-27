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

dependency "SG" {
  config_path = "../ec2-powerdns-sg/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git///?ref=v3.3.0"
}

inputs = {
  name = "smb-powerdns-${local.environment}"

  associate_public_ip_address = true
  disable_api_termination     = true
  ebs_optimized               = false

  subnet_id = dependency.vpc.outputs.public_subnets[0]

  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  key_name      = "smb-staging"

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 25
    }
  ]

  vpc_security_group_ids = [dependency.SG.outputs.security_group_id]

  monitoring = true

  enable_volume_tags = true
  volume_tags        = local.tags
  tags               = local.tags
}
