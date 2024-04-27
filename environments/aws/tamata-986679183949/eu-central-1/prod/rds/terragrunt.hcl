include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v3.5.0"
}

# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest?tab=inputs
inputs = {
  identifier = local.environment

  engine               = "mariadb"
  engine_version       = "10.5.12"
  family               = "mariadb10.5"
  major_engine_version = "10.5"
  instance_class       = "db.t3.micro"
  allocated_storage    = 10
  storage_type         = "gp2"
  storage_encrypted    = true
  multi_az             = true
  publicly_accessible  = true

  name     = "TamataStaging"
  username = "admin"
  password = local.secrets.password
  port     = "3306"

  iam_database_authentication_enabled = false

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 30

  monitoring_interval    = "30"
  monitoring_role_name   = "RDSMonitoringRole"
  create_monitoring_role = true

  subnet_ids = dependency.vpc.outputs.public_subnets #database_subnets

  deletion_protection = true

  tags = local.tags
}
