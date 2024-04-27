include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("dev.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

dependency "security_group_allow_mysql_from_vpn" {
  config_path = "../../security-groups/allow-mysql-from-vpn"
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git///?ref=v7.6.0"
}

inputs = {
  name           = "tasleem-dev"
  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "5.7.mysql_aurora.2.10.2"

  create_random_password = false
  master_password        = local.secrets.masterPassword

  instances = {
    1 = {
      instance_class               = "db.t4g.medium"
      performance_insights_enabled = true
      storage_encrypted            = true
    }
  }

  vpc_id               = dependency.vpc.outputs.vpc_id
  subnets              = dependency.vpc.outputs.private_subnets
  db_subnet_group_name = "tasleem-dev"
  network_type         = "IPV4"

  allowed_cidr_blocks    = dependency.vpc.outputs.private_subnets_cidr_blocks
  vpc_security_group_ids = [dependency.security_group_allow_mysql_from_vpn.outputs.security_group_id]

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "tasleem-dev"
  db_cluster_parameter_group_family      = "aurora-mysql5.7"
  db_cluster_parameter_group_description = "Tasleem dev environment cluster parameter group."

  create_db_parameter_group      = true
  db_parameter_group_name        = "tasleem-dev"
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "Tasleem dev environment cluster parameter group."

  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]

  preferred_maintenance_window = "Mon:00:00-Mon:03:00"
  preferred_backup_window      = "03:01-06:00"
  backup_retention_period      = 7

  iam_role_name       = "aurora-rds-monitoring-role-tasleem-dev"
  monitoring_interval = "30"

  deletion_protection = true

  copy_tags_to_snapshot = true

  tags = local.tags
}
