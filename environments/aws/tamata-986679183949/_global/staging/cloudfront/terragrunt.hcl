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
  config_path = "../../../us-east-1/acm/tamata.com/"
}

dependency "logging_bucket" {
  config_path = "../../../us-east-1/s3/cloudfront-logging/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-cloudfront.git///?ref=v2.9.2"
}

inputs = {
  enabled = true

  aliases = [
    "aws-staging.tamata.com"
  ]

  is_ipv6_enabled  = false
  retain_on_delete = false

  create_monitoring_subscription = true

  logging_config = {
    bucket = dependency.logging_bucket.outputs.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  price_class = "PriceClass_All"

  # web_acl_id = "arn:aws:wafv2:us-east-1:986679183949:global/webacl/tamata-staging/e003c1a8-8e3a-45ab-a8dc-f536604fa15d"

  origin = {
    staging = {
      domain_name = "k8s-tamatastaging-c488fd714b-1740355504.eu-central-1.elb.amazonaws.com"

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "staging"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  }

  ordered_cache_behavior = [
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/media/*"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/catalog/category/view/*"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/catalog/product/view/*"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/rbvendor/microsite_vendor/product/*"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/rest/V1/home-page"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/rest/en/V1/home-page"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    },
    {
      cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", ]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/rest/ar/V1/home-page"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
    }
  ]

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2021"
    acm_certificate_arn      = dependency.acm.outputs.acm_certificate_arn
    ssl_support_method       = "sni-only"
  }

  tags = local.tags
}
