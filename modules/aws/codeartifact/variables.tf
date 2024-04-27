variable "tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)
}

variable "repository" {
  type    = string
  default = "creative"
}

variable "domain" {
  type    = string
  default = "creative"
}

variable "kms_key" {
  type    = string
  default = ""
}

variable "principals" {
  description = "List of principals to allow to work with CodeArtifact"
  type        = list(string)
  default     = []
}
