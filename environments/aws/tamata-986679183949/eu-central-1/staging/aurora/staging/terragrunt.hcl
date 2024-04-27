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

dependency "security_group_allow_mysql_from_vpn" {
  config_path = "../../security-groups/allow-mysql-from-vpn"
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git///?ref=v7.6.0"
}

inputs = merge(
  local.secrets,
  {
    name                  = "${local.environment}-cluster"
    engine                = "aurora-mysql"
    engine_mode           = "provisioned"
    engine_version        = "5.7.mysql_aurora.2.10.2"


    instances = {
      1 = {
        instance_class                  = "db.r6g.large"
        publicly_accessible             = false
        promotion_tier                  = 1
        storage_encrypted               = true
      },
      2 = {
        instance_class                  = "db.r6g.xlarge"
        publicly_accessible             = false
        promotion_tier                  = 1
        storage_encrypted               = true
      }
    }

    vpc_id                = dependency.vpc.outputs.vpc_id
    subnets               = dependency.vpc.outputs.database_subnets
    db_subnet_group_name  = local.environment

    allowed_cidr_blocks   = dependency.vpc.outputs.private_subnets_cidr_blocks
    vpc_security_group_ids = [dependency.security_group_allow_mysql_from_vpn.outputs.security_group_id]

    apply_immediately   = true

    create_db_cluster_parameter_group      = true
    db_cluster_parameter_group_name        = "${local.environment}-cluster"
    db_cluster_parameter_group_family      = "aurora-mysql5.7"
    db_cluster_parameter_group_description = "${local.environment} cluster parameter group."

    create_db_parameter_group      = true
    db_parameter_group_name        = "${local.environment}"
    db_parameter_group_family      = "aurora-mysql5.7"
    db_parameter_group_description = "${local.environment} parameter group."
    db_parameter_group_parameters = [
      {
	name  = "slow_query_log"
	value = 1
      },
      {
	name  = "long_query_time"
	value = 2
      },
      {
	name = "log_output"
	value = "FILE"
      }
    ]

    performance_insights_enabled    = true
    enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]

    preferred_maintenance_window = "Mon:00:00-Mon:03:00"
    preferred_backup_window      = "03:00-06:00"
    backup_retention_period      = 15

    deletion_protection = true

    database_name = "TamataStaging"

    create_monitoring_role = true
    iam_role_name          = "AuroraRDSMonitoringRole"
    monitoring_interval    = "30"

    copy_tags_to_snapshot = true

    tags = local.tags
  }
)
