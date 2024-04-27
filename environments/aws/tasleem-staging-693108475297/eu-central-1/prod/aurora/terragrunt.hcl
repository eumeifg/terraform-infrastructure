include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "security_group_allow_mysql_from_database_subnets" {
  config_path = "../security-groups/allow-mysql-from-database-subnets"
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git///?ref=v7.5.0"
}

inputs = {
  name           = "tasleem-production"
  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "5.7.mysql_aurora.2.10.3"

  create_random_password = false
  master_password        = local.secrets.masterPassword

  instances = {
    1 = {
      instance_class               = "db.t4g.large"
      performance_insights_enabled = true
      storage_encrypted            = true
    },
    2 = {
      instance_class               = "db.t4g.large"
      performance_insights_enabled = true
      storage_encrypted            = true
    }
  }

  vpc_id                  = dependency.vpc.outputs.vpc_id
  subnets                 = dependency.vpc.outputs.database_subnets
  allowed_cidr_blocks     = dependency.vpc.outputs.private_subnets_cidr_blocks
  allowed_security_groups = [dependency.security_group_allow_mysql_from_database_subnets.outputs.security_group_id]
  db_subnet_group_name    = "tasleem-production"
  network_type            = "IPV4"

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "tasleem-production"
  db_cluster_parameter_group_family      = "aurora-mysql5.7"
  db_cluster_parameter_group_description = "Tasleem production environment cluster parameter group."

  create_db_parameter_group      = true
  db_parameter_group_name        = "tasleem-production"
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "Tasleem production environment cluster parameter group."

  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]

  preferred_maintenance_window = "Mon:00:00-Mon:03:00"
  preferred_backup_window      = "03:00-06:00"
  backup_retention_period      = 30

  iam_role_name       = "aurora-rds-monitoring-role-tasleem-production"
  monitoring_interval = "30"

  deletion_protection = true

  copy_tags_to_snapshot = true

  db_cluster_parameter_group_parameters = [
    {
      name  = "max_connections"
      value = 250
    }
  ]

  tags = local.tags
}
