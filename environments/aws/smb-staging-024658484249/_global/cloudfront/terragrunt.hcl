include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}


dependency "acm" {
  config_path = "../../us-east-1/acm/creativeadvtech.ml/"
}

dependency "staging_s3" {
  config_path = "../../eu-central-1/s3/smb-cs-store/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-cloudfront.git///?ref=v2.9.1"
}

inputs = {
  enabled = true

  aliases = [
    "smb-cs-store.creativeadvtech.ml"
  ]

  is_ipv6_enabled  = false
  retain_on_delete = false

  create_origin_access_identity = true
  origin_access_identities = {
    staging = "CloudFront can access staging origin"
  }

  price_class = "PriceClass_All"

  origin = {
    staging = {
      domain_name = dependency.staging_s3.outputs.s3_bucket_bucket_domain_name
      s3_origin_config = {
        origin_access_identity = "staging" # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "staging"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    # cache_policy_id = "5a567638-c2aa-4cbb-bd29-44673d0f9fd8"
  }

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2021"
    acm_certificate_arn      = dependency.acm.outputs.acm_certificate_arn
    ssl_support_method       = "sni-only"
  }

  tags = local.tags
}
