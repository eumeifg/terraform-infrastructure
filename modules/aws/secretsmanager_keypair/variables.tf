variable "name_prefix" {
  type        = string
  description = "Prefix to add to keypair/secret name"
}

variable "description" {
  type        = string
  description = "Description of secret"
  default     = "ssh key"
}

variable "tags" {
  type        = map(string)
  description = "Tags to add to supported resources"
  default     = {}
}
