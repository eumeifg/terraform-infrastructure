variable "master_account_name" {
  type = string
}

variable "email" {
  type = string
}

variable "iam_user_access_to_billing" {
  type    = string
  default = null
}

variable "role_name" {
  type    = string
  default = null
}

variable "feature_set" {
  description = "Specify 'ALL' (default) or 'CONSOLIDATED_BILLING'."
  default     = "ALL"
}

variable "aws_service_access_principals" {
  type    = list(string)
  default = []
}

variable "enabled_policy_types" {
  type    = list(string)
  default = []
}

variable "main_ou" {
  type    = string
  default = ""
}

variable "projects" {
  type    = string
  default = ""
}

variable "sandboxes" {
  type    = string
  default = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
