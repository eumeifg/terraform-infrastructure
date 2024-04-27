variable "helmfile_content" {
  description = "Actual helmfile.yml content"
  type        = string
}

variable "kubeconfig" {
  type        = string
  description = "Absolute path to a kubeconfig file"
}

variable "values" {
  type = map(any)
  description = "Helmfile values for templating"
  default = {}
}

variable "environment" {
  type = string
  description = "Helmfile environment name"
  default = null
}
