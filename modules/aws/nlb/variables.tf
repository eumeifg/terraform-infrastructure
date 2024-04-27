variable "nlb_name" {
  description = "The name of the LB."
  type        = string
}

variable "alb_name" {
  description = "The name of the ALB."
  type        = string
}

variable "load_balancer_type" {
  description = "Type of loadbalancer."
  type        = string
}

variable "vpc_id" {
  description = "(Required) VPC ID to associate with LB."
  type        = string
}

variable "nlb_internal" {
  description = "A boolean flag to determine whether the Load Balancer should be internal."
  type        = bool
  default     = false
}

variable "nlb_subnet_ids" {
  description = "(Required) A list of subnet IDs to associate with Load Balancer."
  type        = list(string)
}

variable "nlb_deletion_protection_enabled" {
  description = "A boolean flag to enable/disable deletion protection for Load Balancer."
  type        = bool
  default     = false
}

variable "nlb_cross_zone_load_balancing_enabled" {
  description = "A boolean flag to enable/disable cross zone load balancing."
  type        = bool
  default     = true
}
variable "nlb_ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer."
  type        = string
  default     = "ipv4"
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
}

variable "port" {
  description = "The port number on which the targets receive traffic. Valid values are either ports 1-65535."
  type        = number
  nullable    = false

  validation {
    condition = alltrue([
      var.port >= 1,
      var.port <= 65535,
    ])
    error_message = "Valid values are either ports 1-65535."
  }
}

variable "health_check" {
  description = <<EOF
  (Optional) Health Check configuration block. The associated load balancer periodically sends requests to the registered targets to test their status. `health_check` block as defined below.
    (Optional) `protocol` - Protocol to use to connect with the target. The possible values are `HTTP` and `HTTPS`. Defaults to `HTTP`.
    (Optional) `port` - The port the load balancer uses when performing health checks on targets. The default is the port on which each target receives traffic from the load balancer. Valid values are either ports 1-65535.
    (Optional) `port_override` - Whether to override the port on which each target receives trafficfrom the load balancer to a different port. Defaults to `false`.
    (Optional) `path` - Use the default path of `/` to ping the root, or specify a custom path if preferred. Only valid if the `protocol` is `HTTP` or `HTTPS`.
    (Optional) `healthy_threshold` - The number of consecutive health checks successes required before considering an unhealthy target healthy. Valid value range is 2 - 10. Defaults to `3`.
    (Optional) `unhealthy_threshold` - The number of consecutive health check failures required before considering a target unhealthy. Valid value range is 2 - 10. Defaults to `3`.
    (Optional) `interval` - Approximate amount of time, in seconds, between health checks of an individual target. Valid value range is 5 - 300. Defaults to `10`.
    (Optional) `timeout` - The amount of time, in seconds, during which no response means a failed health check. Valid value range is 2 - 120. Defaults to `6` when the `protocol` is `HTTP`, and `10` when the `protocol` is `HTTPS`.
  EOF
  type = object({
    protocol      = optional(string, "HTTP")
    port          = optional(number, null)
    path          = optional(string, "/")
    healthy_threshold   = optional(number, 3)
    unhealthy_threshold = optional(number, 3)
    interval            = optional(number, 10)
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      contains(["HTTP", "HTTPS"], var.health_check.protocol),
      coalesce(var.health_check.port, 80) >= 1,
      coalesce(var.health_check.port, 80) <= 65535,
      length(var.health_check.path) <= 1024,
      var.health_check.healthy_threshold <= 10,
      var.health_check.healthy_threshold >= 2,
      var.health_check.unhealthy_threshold <= 10,
      var.health_check.unhealthy_threshold >= 2,
      contains([10, 30], var.health_check.interval),
    ])
    error_message = "Not valid parameters for `health_check`."
  }
}

variable "listener_default_action_type" {
  description = "The type of routing action."
  type    = string
  default = "forward"
}

variable "protocol" {
  description = "(Required) The protocol for connections from clients to the load balancer. Valid values are `TCP`, `TLS`, `UDP` and `TCP_UDP`. Not valid to use `UDP` or `TCP_UDP` if dual-stack mode is enabled on the load balancer."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["TCP", "TLS", "UDP", "TCP_UDP"], var.protocol)
    error_message = "Valid values are `TCP`, `TLS`, `UDP` and `TCP_UDP`. Not valid to use `UDP` or `TCP_UDP` if dual-stack mode is enabled on the load balancer."
  }
}

variable "tls_certificate" {
  description = "(Optional) The ARN of the default SSL server certificate. For adding additional SSL certificates, see the `tls_additional_certificates` variable. Required if `protocol` is `TLS`."
  type        = string
  default     = null
}

variable "tls_security_policy" {
  description = "(Optional) The name of security policy for a Secure Socket Layer (SSL) negotiation configuration. This is used to negotiate SSL connections with clients. Required if protocol is `TLS`. Recommend using the `ELBSecurityPolicy-TLS13-1-2-2021-06` security policy. This security policy includes TLS 1.3, which is optimized for security and performance, and is backward compatible with TLS 1.2."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  nullable    = false
}

variable "tls_alpn_policy" {
  description = "(Optional) The policy of the Application-Layer Protocol Negotiation (ALPN) to select. ALPN is a TLS extension that includes the protocol negotiation within the exchange of hello messages. Can be set if `protocol` is `TLS`. Valid values are `HTTP1Only`, `HTTP2Only`, `HTTP2Optional`, `HTTP2Preferred`, and `None`. Defaults to `None`."
  type        = string
  default     = "None"
  nullable    = false

  validation {
    condition     = contains(["None", "HTTP1Only", "HTTP2Only", "HTTP2Optional", "HTTP2Preferred"], var.tls_alpn_policy)
    error_message = "Valid values are `HTTP1Only`, `HTTP2Only`, `HTTP2Optional`, `HTTP2Preferred`, and `None`. Defaults to `None`."
  }
}

variable "tags_all" {
  type = map(string)
}
