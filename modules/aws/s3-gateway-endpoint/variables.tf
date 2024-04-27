variable "policy" {
  type = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "route_table_ids" {
  default = []
  type    = list(string)
}
