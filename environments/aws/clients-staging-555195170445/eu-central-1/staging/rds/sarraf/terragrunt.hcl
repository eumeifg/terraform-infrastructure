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


dependency "security_group" {
  config_path = "../../security-groups/rds/"
}

dependency "vpc" {
  config_path = "../../vpc/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v4.7.0"
}

inputs = {
  identifier = "sarraf-staging"

  engine                = "postgres"
  engine_version        = "14.4"
  family                = "postgres14"
  major_engine_version  = "14.4"
  instance_class        = "db.t3.small"
  allocated_storage     = 64
  max_allocated_storage = 512
  multi_az              = true

  create_db_subnet_group = true
  subnet_ids             = dependency.vpc.outputs.database_subnets
  db_subnet_group_name   = "sarraf-staging"

  username = "postgres"
  password = local.secrets.password
  port     = "5432"

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 14
  copy_tags_to_snapshot   = true

  create_db_option_group          = false
  parameter_group_name            = "sarraf-staging"
  parameter_group_use_name_prefix = false
  create_monitoring_role          = false
  monitoring_role_name            = "rds-monitoring-role"
  monitoring_role_arn             = "arn:aws:iam::555195170445:role/rds-monitoring-role"
  monitoring_interval             = "30"
  subnet_ids                      = dependency.vpc.outputs.database_subnets

  vpc_security_group_ids = [
    dependency.security_group.outputs.security_group_id,
  ]

  deletion_protection = true

  tags = local.tags
}
