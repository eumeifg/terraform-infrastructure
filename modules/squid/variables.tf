variable "aws_key_name" {
  description = "SSH keypair name for the VPN instance"
}

variable "vpc_id" {
  description = "Which VPC VPN server will be created in"
}

variable "public_subnet_id" {
  description = "One of the public subnet id for the VPN instance"
}

variable "instance_type" {
  description = "Instance type for Squid Proxy"
  type        = string
  default     = "t3a.small"
}

variable "inst_profile" {
  description = "ARN of the instance profile for a host"
  type        = string
  default     = ""
}

variable "whitelist" {
  description = "[List] Office IP CIDRs for SSH and HTTPS"
  type        = list(string)
}

variable "whitelist_http" {
  description = "[List] Whitelist for HTTP port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
  type        = map(string)
}

variable "resource_name_prefix" {
  description = "All the resources will be prefixed with the value of this variable"
  default     = "squid"
}



