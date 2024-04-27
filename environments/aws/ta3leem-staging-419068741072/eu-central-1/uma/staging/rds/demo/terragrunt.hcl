include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("uma-staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("${get_terragrunt_dir()}/secrets.enc.yaml"))
}

dependencies {
  paths = ["../../security-groups/sql-server"]
}

dependency "security_group" {
  config_path = "../../security-groups/sql-server"
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v5.1.0"
}

inputs = {
  identifier = "uma-demo"

  engine                = "sqlserver-ex"
  engine_version        = "15.00.4153.1.v1"
  family                = "sqlserver-ex-15.0"
  major_engine_version  = "15.00"
  instance_class        = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 128
  storage_encrypted     = false
  multi_az              = false

  create_db_subnet_group = true
  subnet_ids             = dependency.vpc.outputs.database_subnets
  db_subnet_group_name   = "uma-demo"

  username = "root"
  password = local.secrets.password
  port     = "1433"

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-05:00"
  backup_retention_period = 7
  copy_tags_to_snapshot   = true

  create_db_option_group          = false
  parameter_group_name            = "uma-demo"
  parameter_group_use_name_prefix = false

  monitoring_interval    = "60"
  create_monitoring_role = true
  monitoring_role_name   = "uma-demo-rds-monitoring-role"

  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["error"]

  subnet_ids = dependency.vpc.outputs.database_subnets

  vpc_security_group_ids = [
    dependency.security_group.outputs.security_group_id,
  ]

  license_model = "license-included"

  deletion_protection = true

  tags = local.tags
}
