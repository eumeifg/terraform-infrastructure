variable "accounts" {
  description = "Map of accounts to create"
  type = map(map(string))

  ## Example:
/*
  accounts = {
    test = {
      email       = "devops@creativeadvtech.com"
      description = "Test account"
      role_name = "Admins"
    },
    staging = {
      email       = "devops@creativeadvtech.com"
      description = "Staging account"
    },
    prod = {
      email       = "devops@creativeadvtech.com"
      description = "Prod account"
    },
  }
*/
}

variable "default_iam_role" {
  type = string
  description = "(Optional) The name of an IAM role that Organizations automatically preconfigures in the new member account. This role trusts the master account, allowing users in the master account to assume the role, as permitted by the master account administrator."
  default = null
}
