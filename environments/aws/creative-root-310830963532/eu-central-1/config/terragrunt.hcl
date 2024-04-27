include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/config///"
}

inputs = {
  region      = "eu-central-1"
  namespace   = "eu"
  environment = "eu1"
  stage       = "prod"

  create_sns_topic                 = false
  create_iam_role                  = false
  iam_role_arn                     = "arn:aws:iam::310830963532:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
  global_resource_collector_region = "eu-central-1"
  force_destroy                    = true
  s3_bucket_id                     = "config-bucket-310830963532"
  s3_bucket_arn                    = "arn:aws:s3:::config-bucket-310830963532"

  managed_rules = {
    account-part-of-organizations = {
      description  = "Checks whether AWS account is part of AWS Organizations. The rule is NON_COMPLIANT if an AWS account is not part of AWS Organizations or AWS Organizations master account ID does not match rule parameter MasterAccountId.",
      identifier   = "ACCOUNT_PART_OF_ORGANIZATIONS",
      trigger_type = "PERIODIC"
      enabled      = true

      input_parameters = {
        MasterAccountId : "310830963532"
      }

      tags = {
        "compliance/cis-aws-foundations/1.2"                                 = true
        "compliance/cis-aws-foundations/filters/global-resource-region-only" = true
        "compliance/cis-aws-foundations/1.2/controls"                        = 1.4
      }
    }
  }
}
