include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "security_group_mysql" {
  config_path = "../../../security-groups/mysql"
}

dependency "security_group_mysql_vpn_ring" {
  config_path = "../../../security-groups/mysql-vpn"
}

dependency "vpc" {
  config_path = "../../../vpc"
}

dependency "staging_frappe" {
  config_path = "../frappe"
}

dependency "production_frappe" {
  config_path = "../../../../prod/rds/frappe"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v4.7.0"
}

inputs = {
  identifier             = "taza-production-frappe-ro-ai"
  replicate_source_db    = dependency.production_frappe.outputs.db_instance_id
  create_random_password = false

  engine               = "mariadb"
  engine_version       = "10.6.10"
  family               = "mariadb10.6"
  major_engine_version = "10.6"
  instance_class       = "db.t4g.medium"

  max_allocated_storage = 512
  iops                  = 3000

  vpc_security_group_ids = [
    dependency.security_group_mysql.outputs.security_group_id,
    dependency.security_group_mysql_vpn_ring.outputs.security_group_id
  ]

  create_db_subnet_group = false
  subnet_ids             = dependency.vpc.outputs.database_subnets
  db_subnet_group_name   = dependency.staging_frappe.outputs.db_subnet_group_id

  create_db_option_group          = false
  create_db_parameter_group       = true
  parameter_group_name            = "taza-production-frappe-ro-ai"
  parameter_group_use_name_prefix = false

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
    },
    {
      name  = "slow_query_log"
      value = 1
    },
    {
      name  = "long_query_time"
      value = 2
    },
    {
      name  = "log_output"
      value = "FILE"
    }
  ]

  maintenance_window      = "Sun:22:00-Mon:01:00"
  backup_window           = "01:00-03:00"
  backup_retention_period = 0
  deletion_protection     = true

  performance_insights_enabled    = false
  enabled_cloudwatch_logs_exports = ["general", "error"]

  tags = local.tags
}
