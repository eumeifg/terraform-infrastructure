variable "thumbprint_list" {
  type    = list(string)
  default = []
}

variable "client_ids" {
  type    = list(string)
  default = []
}

variable "identity_provider_url" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
