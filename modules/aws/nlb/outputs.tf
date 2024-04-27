output "nlb_name" {
  description = "The name of the load balancer."
  value       = aws_lb.this.name
}

output "nlb_arn_suffix" {
  description = "The ARN suffix of the ALB for use with CloudWatch Metrics."
  value       = join("", aws_lb.this.*.arn_suffix)
}


output "nlb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = join("", aws_lb.this.*.dns_name)
}


output "tg_name" {
  description = "The name of the target group."
  value       = aws_lb_target_group.this.name
}

output "tg_arn" {
  description = "The Amazon Resource Name (ARN) of the target group."
  value       = aws_lb_target_group.this.arn
}

output "listener_arn" {
  description = "The Amazon Resource Name (ARN) of the listener."
  value       = aws_lb_listener.this.arn
}

output "listener_port" {
  description = "The port number on which the listener of load balancer is listening."
  value       = aws_lb_listener.this.port
}

output "listener_protocol" {
  description = "The protocol for connections of the listener."
  value       = aws_lb_listener.this.protocol
}

output "default_action" {
  description = "The default action for traffic on this listener."
  value = {
    type = "FORWARD"
    forward = {
      arn  = aws_lb_target_group.this.arn
      name = split("/", aws_lb_target_group.this.arn)[1]
    }
  }
}

