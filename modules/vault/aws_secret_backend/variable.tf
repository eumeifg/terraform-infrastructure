variable "name" {
  description = "Name of the backend"
  type = string
}

variable "credential_type" {
  description = "Type of credential: assumed_role, iam_user e.t.c"
  type = string
}

variable "access_key" {
  description = "Access key for the vault user"
  type = string
}

variable "secret_key" {
  description = "Secret key for the vault user"
  type = string
}

variable "role_arns" {
  description = "Role arn of the default iam role"
  type = list(string)
}
