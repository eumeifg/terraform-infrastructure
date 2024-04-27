include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("${get_terragrunt_dir()}/secrets.enc.yaml"))
}

dependencies {
  paths = ["../../../security-groups/mysql"]
}

dependency "security_group" {
  config_path = "../../../security-groups/mysql"
}

dependency "security_group_mysql_vpn_ring" {
  config_path = "../../../security-groups/mysql-vpn"
}

dependency "vpc" {
  config_path = "../../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git///?ref=v4.7.0"
}

inputs = {
  identifier = "taza-dev-frappe"

  engine                = "mariadb"
  engine_version        = "10.6.10"
  family                = "mariadb10.6"
  major_engine_version  = "10.6"
  instance_class        = "db.t4g.small"
  allocated_storage     = 8
  max_allocated_storage = 128

  create_db_subnet_group = true
  subnet_ids             = dependency.vpc.outputs.database_subnets
  db_subnet_group_name   = "taza-dev-frappe"

  username = "root"
  password = local.secrets.password
  port     = "3306"

  maintenance_window      = "Sun:22:00-Mon:01:00"
  backup_window           = "01:00-03:00"
  backup_retention_period = 7
  copy_tags_to_snapshot   = true

  create_db_option_group          = false
  parameter_group_name            = "taza-dev-frappe"
  parameter_group_use_name_prefix = false

  create_monitoring_role = false
  monitoring_role_arn    = "arn:aws:iam::333991225879:role/rds-monitoring-role"
  monitoring_interval    = "60"

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
