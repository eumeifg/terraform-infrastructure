locals {
  tls_enabled = var.protocol == "TLS"
}

resource "aws_lb" "this" {
  name                             = var.nlb_name
  internal                         = var.nlb_internal
  load_balancer_type               = "network"
  subnets                          = var.nlb_subnet_ids
  enable_deletion_protection       = var.nlb_deletion_protection_enabled
  enable_cross_zone_load_balancing = var.nlb_cross_zone_load_balancing_enabled
  ip_address_type                  = var.nlb_ip_address_type
  tags                             = var.tags_all
}

resource "aws_lb_target_group" "this" {
  name        = var.tg_name
  vpc_id      = var.vpc_id
  target_type = "alb"
  port        = var.port
  protocol    = "TCP"
  tags        = var.tags_all

  health_check {
    enabled = true

    protocol            = var.health_check.protocol
    port                = "traffic-port"
    path                = var.health_check.path
    matcher             = "200-399"
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    interval            = var.health_check.interval
  }
}

resource "aws_lb_target_group" "https-this" {
  name        = "${var.tg_name}-https"
  vpc_id      = var.vpc_id
  target_type = "alb"
  port        = 443
  protocol    = "TCP"
  tags        = var.tags_all

  health_check {
    enabled = true

    protocol            = var.health_check.protocol
    port                = "traffic-port"
    path                = var.health_check.path
    matcher             = "200-399"
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    interval            = var.health_check.interval
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = data.aws_lb.alb.id
  port             = var.port
}

resource "aws_lb_target_group_attachment" "https-this" {
  target_group_arn = aws_lb_target_group.https-this.arn
  target_id        = data.aws_lb.alb.id
  port             = 443
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = var.protocol

  ## TLS
  certificate_arn = local.tls_enabled ? var.tls_certificate : null
  ssl_policy      = local.tls_enabled ? var.tls_security_policy : null
  alpn_policy     = local.tls_enabled ? var.tls_alpn_policy : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags_all
}

resource "aws_lb_listener" "https-this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = var.protocol

  ## TLS
  certificate_arn = local.tls_enabled ? var.tls_certificate : null
  ssl_policy      = local.tls_enabled ? var.tls_security_policy : null
  alpn_policy     = local.tls_enabled ? var.tls_alpn_policy : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https-this.arn
  }

  tags = var.tags_all
}
