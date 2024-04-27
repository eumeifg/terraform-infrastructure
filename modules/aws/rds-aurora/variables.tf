variable "name" {
  type        = string
  description = "Name of the Aurora DB"
}

variable "engine" {
  type        = string
  description = "The name of the database engine to be used for this DB cluster."
}

variable "engine_version" {
  type        = string
  description = "The name of the database engine to be used for this DB cluster."
  default     = ""
}

variable "engine_mode" {
  type        = string
  description = "The database engine mode. Valid values: `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless`."
  default     = "provisioned"
}

variable "instance_class" {
  type        = string
  description = "Instance type to use at master instance."
  default     = ""
}

variable "instances" {
  type        = any
  description = "Map of cluster instances and any specific/overriding attributes to be created"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where to create security group"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs used by database subnet group created"
}

variable "autoscaling_enabled" {
  type        = bool
  description = "Determines whether autoscaling of the cluster read replicas is enabled"
  default = false
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum number of read replicas permitted when autoscaling is enabled"
  default = 1
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum number of read replicas permitted when autoscaling is enabled"
  default = 1
}

variable "create_security_group" {
  type        = bool
  description = "Determines whether to create security group for RDS cluster"
  default = false
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default = false
}

variable "create_random_password" {
  type        = bool
  description = "Determines whether to create random password for RDS primary cluster"
  default = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  default = false
}

variable "master_password" {
  type        = string
  description = "Password for the master DB user. Note - when specifying a value here, 'create_random_password' should be set to `false`"
}

variable "db_parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group to associate with instances"
}

variable "db_cluster_parameter_group_name" {
  type        = string
  description = "A cluster parameter group to associate with the cluster"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql`"
  default = []
}

variable "family" {
  type        = string
  description = "RDS Parameter Group family name"
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "Security group ingress rules"
  default = []
  type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
}

variable "egress" {
  description = "Security group egress rules"
  default     = []
  type        = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
