variable "custom_ami" {}

variable "name" {}

variable "availability_zone" {}

variable "dedicated_host_id" {}

variable "key_name" {}

variable "subnet_id" {}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}
