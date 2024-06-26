variable "role_name" {
  description = "Role name"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of policy arns to attach to this role"
  default     = [""]
}

variable "policy_arns_count" {
  description = "number of policy arns due to bug with length of computed value"
}

variable "create_instance_role" {
  description = "Need to create a same name instance role or not"
  default     = false
}
