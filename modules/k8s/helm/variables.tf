variable "release_name" {
  type    = string
  default = ""
}

variable "repository_url" {
  type    = string
  default = ""
}

variable "chart_name" {
  type    = string
  default = ""
}

variable "chart_version" {
  type    = string
  default = ""
}

variable "values_file" {
  type    = string
  default = ""
}

variable "namespace" {
  default = ""
  type    = string
}

variable "create_namespace" {
  default = false
  type    = bool
}
