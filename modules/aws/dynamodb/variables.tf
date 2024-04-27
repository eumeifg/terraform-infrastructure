variable "name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "billing_mode" {
  type        = string
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  type        = string
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
}

variable "range_key" {
  type        = string
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  default     = ""
}

variable "read_capacity" {
  type        = number
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
}

variable "write_capacity" {
  type        = number
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
