include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
  secrets     = yamldecode(sops_decrypt_file("${get_terragrunt_dir()}/secrets.enc.yaml"))
}

dependencies {
  paths = ["../mysql-SG"]
}

dependency "security_group" {
  config_path = "../mysql-SG"
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git///?ref=v6.0.0"
}

inputs = merge(
  local.secrets,
  {
    name                  = "${local.environment}-cluster"
    engine                = "aurora-mysql"
    engine_mode           = "provisioned"
    engine_version        = "5.7.mysql_aurora.2.10.3"
    engine_version_actual = "5.7.mysql_aurora.2.10.3"


    instances = {
      1 = {
        instance_class                  = "db.r6g.2xlarge"
        publicly_accessible             = false
        monitoring_interval             = 15
        engine_version_actual           = "5.7.mysql_aurora.2.10.3"
        db_parameter_group_name         = "default.aurora-mysql5.7"
        db_cluster_parameter_group_name = "custom-parameter-group"
        promotion_tier                  = 1
        storage_encrypted               = true
      },
      2 = {
        instance_class                  = "db.r6g.2xlarge"
        publicly_accessible             = false
        monitoring_interval             = 15
        engine_version_actual           = "5.7.mysql_aurora.2.10.3"
        db_parameter_group_name         = "default.aurora-mysql5.7"
        db_cluster_parameter_group_name = "custom-parameter-group"
        promotion_tier                  = 1
        storage_encrypted               = true
      }
    }

    vpc_id                = dependency.vpc.outputs.vpc_id
    subnets               = dependency.vpc.outputs.database_subnets
    availability_zones    = dependency.vpc.outputs.azs
    create_security_group = true
    allowed_cidr_blocks   = dependency.vpc.outputs.private_subnets_cidr_blocks
    db_subnet_group_name  = local.environment

    apply_immediately   = true
    skip_final_snapshot = true

    db_cluster_parameter_group_name = "default.aurora-mysql5.7"

    performance_insights_enabled    = true
    enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]

    preferred_maintenance_window = "Mon:00:00-Mon:03:00"
    preferred_backup_window      = "03:00-06:00"
    backup_retention_period      = 30

    deletion_protection = true

    database_name = "tamataProd"

    create_monitoring_role = true
    iam_role_name          = "AuroraRDSMonitoringRole-prod"
    monitoring_interval    = "30"

    copy_tags_to_snapshot = true

    tags = local.tags
  }
)
