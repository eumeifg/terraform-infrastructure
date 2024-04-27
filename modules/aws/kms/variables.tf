variable "is_enabled" {
  type        = bool
  description = "Specifies whether the key is enabled. Defaults to true."

  default = true
}

variable "description" {
  type        = string
  description = "The description of the key as viewed in AWS console."

  default = ""
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled. Defaults to false."

  default = false
}

variable "deletion_window_in_days" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."

  default = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "Value for deletion_window_in_days must be between 7 and 30 days."
  }
}

variable "policy" {
  type        = string
  description = "A valid policy JSON document."

  default = null
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."

  default = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY"], var.key_usage)
    error_message = "Value for key_usage must be either ENCRYPT_DECRYPT or SIGN_VERIFY."
  }
}

variable "customer_master_key_spec" {
  type        = string
  description = <<-EOT
      Specifies whether the key contains a symmetric key or an asymmetric key pair and
      the encryption algorithms or signing algorithms that the key supports.
      Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096,
      ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1.

      Defaults to SYMMETRIC_DEFAULT.
  EOT

  default = "SYMMETRIC_DEFAULT"

  validation {
    condition = contains(
      ["SYMMETRIC_DEFAULT", "RSA_2048", "RSA_3072", "RSA_4096", "ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521", "ECC_SECG_P256K1"],
      var.customer_master_key_spec
    )
    error_message = "Value for key_usage is not valid. See variable description for valid values."
  }
}

variable "alias_name" {
  type        = string
  description = "The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"

  default = "alias/"

  validation {
    condition     = length(var.alias_name) > 6 && substr(var.alias_name, 0, 6) == "alias/"
    error_message = "Value for alias_name is invalid. Must be in a 'alias/some_name' format."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the objects."

  default = {}
}
