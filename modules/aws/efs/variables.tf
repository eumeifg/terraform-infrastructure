variable "creation_token" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "encrypted" {
  type = bool
  default = false
}

variable "kms_key_id" {
  type = string
  default = null
}

variable "performance_mode" {
  type = string
  default = "generalPurpose"
}

variable "security_groups" {
  type = list(string)
  default = []
}

variable "subnets" {
  type = list(string)
  default = []
}
