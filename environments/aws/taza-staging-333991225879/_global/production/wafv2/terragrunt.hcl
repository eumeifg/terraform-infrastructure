include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependency "wafv2_ip_set_windows_qa_test_instances" {
  config_path = "../../wafv2-ip-set/windows-qa-test-instances"
}

dependency "wafv2_ip_set_dubai_office_egress" {
  config_path = "../../wafv2-ip-set/dubai-office-egress"
}

dependency "wafv2_ip_set_taza_baghdad_office_egress" {
  config_path = "../../wafv2-ip-set/taza-baghdad-office-egress"
}

terraform {
  source = "git@github.com:umotif-public/terraform-aws-waf-webaclv2.git///?ref=3.8.1"
}

inputs = {
  name_prefix = "taza-production"

  scope = "CLOUDFRONT"

  create_alb_association = false

  allow_default_action = true

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "taza-production-waf-main-metrics"
    sampled_requests_enabled   = true
  }

  custom_response_bodies = [
    {
      key          = "high-traffic-detected",
      content      = "The request could not be satisfied. High traffic detected, please contact Taza support if you think your device didn't generate high traffic.",
      content_type = "TEXT_PLAIN"
    }
  ]

  rules = [
    {
      name     = "allow-windows-qa-test-instances"
      priority = "0"
      action   = "allow"

      ip_set_reference_statement = {
        arn = dependency.wafv2_ip_set_windows_qa_test_instances.outputs.aws_wafv2_ip_set_arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "taza-production-waf-allow-windows-qa-test-instances-metrics"
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "allow-dubai-office-egress"
      priority = "1"
      action   = "allow"

      ip_set_reference_statement = {
        arn = dependency.wafv2_ip_set_dubai_office_egress.outputs.aws_wafv2_ip_set_arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "taza-production-waf-allow-dubai-office-egress--metrics"
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "allow-taza-baghdad-office-egress"
      priority = "2"
      action   = "allow"

      ip_set_reference_statement = {
        arn = dependency.wafv2_ip_set_taza_baghdad_office_egress.outputs.aws_wafv2_ip_set_arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "taza-production-waf-allow-taza-baghdad-office-egress--metrics"
        sampled_requests_enabled   = false
      }
    },
    {
      name        = "block-ip-rate-based-over-request-for-register-or-change-phone-or-reset-password"
      priority    = "3"
      action      = "block"
      rule_labels = ["IPRateBasedA"]

      custom_response = {
        custom_response_body_key = "high-traffic-detected",
        response_code            = 403
      }

      rate_based_statement = {
        limit              = 100
        aggregate_key_type = "IP"

	scope_down_statement = {
	  or_statement = {
	    statements = [
	      {
		byte_match_statement = {
		  field_to_match = {
		    uri_path = "{}"
		  }
		  positional_constraint = "CONTAINS"
		  search_string         = "auth/register"
		  priority              = 0
		  type                  = "NONE"
		}
	      },
	      {
		byte_match_statement = {
		  field_to_match = {
		    uri_path = "{}"
		  }
		  positional_constraint = "CONTAINS"
		  search_string         = "user/change-phone"
		  priority              = 0
		  type                  = "NONE"
		}
	      },
	      {
		byte_match_statement = {
		  field_to_match = {
		    uri_path = "{}"
		  }
		  positional_constraint = "CONTAINS"
		  search_string         = "auth/reset-password"
		  priority              = 0
		  type                  = "NONE"
		}
	      }
	    ]
	  }
	}
      }
      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "taza-production-waf-ip-rate-based-metrics"
        sampled_requests_enabled   = false
      }
    },
    {
      name        = "block-ip-rate-based-over-request"
      priority    = "4"
      action      = "block"
      rule_labels = ["IPRateBasedA"]

      custom_response = {
        custom_response_body_key = "high-traffic-detected",
        response_code            = 403
      }

      rate_based_statement = {
        limit              = 5000
        aggregate_key_type = "IP"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "taza-production-waf-ip-rate-based-metrics"
        sampled_requests_enabled   = false
      }
    }
  ]

  tags = local.tags
}
