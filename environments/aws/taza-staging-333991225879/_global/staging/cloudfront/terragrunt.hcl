include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "acm" {
  config_path = "../../../us-east-1/acm/creativeadvtech.ml/"
}

dependency "logging_bucket" {
  config_path = "../../s3/taza-cloudfront-logs/"
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-cloudfront.git///?ref=v2.9.3"
}

inputs = {
  enabled = true

  aliases = [
    "frappe.staging.taza.creativeadvtech.ml",
    "fastapi.staging.taza.creativeadvtech.ml",
    "customer-frontend.staging.taza.creativeadvtech.ml"
  ]

  comment = "Taza staging Cloudfront"

  is_ipv6_enabled  = false
  retain_on_delete = false

  create_monitoring_subscription = true

  logging_config = {
    bucket = dependency.logging_bucket.outputs.s3_bucket_bucket_domain_name
    prefix = "staging"
  }

  price_class = "PriceClass_All"

  origin = {
    staging = {
      domain_name = "k8s-tazastaging-5e261b4bba-1090476771.eu-central-1.elb.amazonaws.com"

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
    use_forwarded_values   = false

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  }

  ordered_cache_behavior = [
    {
      cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/cart"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/favourites"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/img"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/css"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "allow-all"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "30b48a77-f8b0-49d2-bf40-a72516264067"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "*.woff"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "30b48a77-f8b0-49d2-bf40-a72516264067"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "*.jpg"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/frappe/Item"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/frappe/Territory"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/customer/banner/list"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/customer/shipping-rule"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/customer/item/list"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/customer/item-group/list"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/frequently-ordered"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/guest-descendant-items"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/guest-similar-items"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/similar-items"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/item/list"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    },
    {
      cache_policy_id          = "f10e4114-8e2c-4b68-8103-1ce7913eb32a"
      origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
      allowed_methods          = ["GET", "HEAD", "OPTIONS"]
      compress                 = true
      default_ttl              = 0
      max_ttl                  = 0
      min_ttl                  = 0
      path_pattern             = "/api/v1/recommender"
      smooth_streaming         = false
      target_origin_id         = "staging"
      viewer_protocol_policy   = "redirect-to-https"
      use_forwarded_values     = false
    }
  ]

  viewer_certificate = {
    minimum_protocol_version = "TLSv1.2_2021"
    acm_certificate_arn      = dependency.acm.outputs.acm_certificate_arn
    ssl_support_method       = "sni-only"
  }

  tags = local.tags
}
