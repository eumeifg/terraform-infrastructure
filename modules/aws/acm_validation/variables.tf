variable "acm_certificate_domain_validation_options" {
  default = []
  type    = list(map(string))
}

variable "aws_route53_zone_id" {
  default = ""
  type    = string
}
