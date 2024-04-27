variable "bundle_id" {
  type        = string
  description = "The AWS Workspace bundle id"

  default = "wsb-gm4d5tx2v" # Value with Windows 10 (Server 2016 based)
}

variable "directory_id" {
  type        = string
  description = "The AWS Active Directory id to login to Windows"

  default = "d-93670cae93"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the objects."

  default = {}
}
