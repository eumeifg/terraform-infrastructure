variable "name" {
  type        = string
  description = "name of the secret"
}

variable "namespace" {
  type        = string
  description = "namespace of the secret"
}

variable "type" {
  type        = string
  description = "type of the secret"
  default     = "Opaque"
}

variable "data" {
  type        = map(any)
  description = "data of the secret"
}
