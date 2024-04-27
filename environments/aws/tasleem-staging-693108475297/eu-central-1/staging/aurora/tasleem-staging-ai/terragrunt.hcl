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

dependency "security_group_allow_mysql_from_vpn" {
  config_path = "../../security-groups/allow-mysql-from-vpn"
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git///?ref=v7.2.2"
}

inputs = {
  name              = "tasleem-staging-ai"
  engine            = "aurora-mysql"
  engine_mode       = "serverless"
  storage_encrypted = true

  create_random_password = false
  master_password        = local.secrets.masterPassword

  vpc_id               = dependency.vpc.outputs.vpc_id
  subnets              = dependency.vpc.outputs.private_subnets
  enable_http_endpoint = true

  allowed_cidr_blocks    = dependency.vpc.outputs.private_subnets_cidr_blocks
  vpc_security_group_ids = [dependency.security_group_allow_mysql_from_vpn.outputs.security_group_id]

  db_cluster_parameter_group_name = "default.aurora-mysql5.7"

  scaling_configuration = {
    auto_pause               = false
    min_capacity             = 1
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "RollbackCapacityChange"
  }

  monitoring_interval          = 60
  create_monitoring_role       = false
  performance_insights_enabled = false

  preferred_maintenance_window = "Mon:00:00-Mon:03:00"
  preferred_backup_window      = "03:00-06:00"

  deletion_protection = true

  copy_tags_to_snapshot = true

  tags = local.tags
}
