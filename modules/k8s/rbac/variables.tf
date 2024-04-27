variable "cluster_role" {
  type = object({
    name = string
    rules = list(object({
      api_groups     = list(string)
      resources      = list(string)
      resource_names = list(string)
      verbs          = list(string)
    }))
  })
  default     = null
  description = "Kubernetes cluster role"
}

variable "cluster_role_binding" {
  type = object({
    name = string
    role_ref = object({
      kind      = string
      name      = string
      api_group = string
    })
    subjects = list(object({
      kind      = string
      name      = string
      api_group = string
    }))
  })
  default     = null
  description = "Kubernetes cluster role binding"
}
