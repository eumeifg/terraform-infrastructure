include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "../../../../../modules/aws/nlb///"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  nlb_name                              = "${local.environment}-nlb"
  load_balancer_type                    = "network"
  vpc_id                                = dependency.vpc.outputs.vpc_id
  nlb_internal                          = false
  nlb_subnet_ids                        = dependency.vpc.outputs.public_subnets
  nlb_deletion_protection_enabled       = true
  nlb_cross_zone_load_balancing_enabled = true
  nlb_ip_address_type                   = "ipv4"
  tg_name                               = "k8s-vpn-alb"
  port                                  = 80

  health_check = {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

  listener_default_action_type = "forward"
  protocol                     = "TCP"
  tls_certificate              = "arn:aws:acm:eu-central-1:614592275287:certificate/f13495de-ec2e-49f0-99ad-3d0457c9ee6a"
  tls_security_policy          = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  tags_all                     = local.tags
}
