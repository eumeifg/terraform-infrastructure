include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/organizations///"
}

inputs = {
  master_account_name = "CreativeAT"
  email               = "bshaker@creativeadvtech.com"
  feature_set         = "ALL"

  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "auditmanager.amazonaws.com",
    "backup.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    "fms.amazonaws.com",
    "guardduty.amazonaws.com",
    "license-management.marketplace.amazonaws.com",
    "license-manager.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "securityhub.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "ssm.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
  ]

  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "BACKUP_POLICY",
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  main_ou   = "Creative AT"
  projects  = "Creative Environments"
  sandboxes = "Users sandboxes"

  tags = local.tags
}
