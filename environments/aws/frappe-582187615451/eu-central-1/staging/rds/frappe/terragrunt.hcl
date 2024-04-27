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

dependencies {
  paths = ["../../security-groups/rds/"]
}

dependency "security_group" {
  config_path = "../../security-groups/rds/"
}


dependency "security_group_mysql_vpn_ring" {
  config_path = "../../security-groups/mysql-vpn/"
}

dependency "vpc" {
  config_path = "../../vpc/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v4.7.0"
}

inputs = {
  identifier = "frappe-staging"

  engine                          = "mariadb"
  engine_version                  = "10.6.10"
  family                          = "mariadb10.6"
  major_engine_version            = "10.6"
  instance_class                  = "db.t4g.large"
  allocated_storage               = 64
  max_allocated_storage           = 512
  multi_az                        = false
  create_db_subnet_group          = true
  subnet_ids                      = dependency.vpc.outputs.database_subnets
  db_subnet_group_name            = "frappe-staging"
  username                        = "root"
  password                        = local.secrets.password
  port                            = "3306"
  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  backup_retention_period         = 14
  copy_tags_to_snapshot           = true
  apply_immediately               = true
  create_db_option_group          = false
  parameter_group_name            = "frappe-staging"
  parameter_group_use_name_prefix = false
  monitoring_role_name            = "rds-monitoring-role"
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["slowquery", "general", "error"]

  subnet_ids = dependency.vpc.outputs.database_subnets

  vpc_security_group_ids = [
    dependency.security_group.outputs.security_group_id,
    dependency.security_group_mysql_vpn_ring.outputs.security_group_id
  ]

  deletion_protection = true

  parameters = [
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "collation_server"
      value = "utf8mb4_unicode_ci"
    },
    {
      name  = "innodb_default_row_format"
      value = "DYNAMIC"
    },
    {
      name  = "innodb_file_per_table"
      value = 1
    }
  ]

  tags = local.tags
}
