module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name = var.name
  engine = var.engine
  engine_version = var.engine_version
  engine_mode = var.engine_mode
  instance_class = var.instance_class

  instances = var.instances

  vpc_id = var.vpc_id
  subnets = var.subnets

  autoscaling_enabled      = var.autoscaling_enabled
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity

  create_security_group               = var.create_security_group
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  create_random_password              = var.create_random_password
  master_password                     = var.master_password
  apply_immediately                   = var.apply_immediately

  db_parameter_group_name         = var.db_parameter_group_name
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  vpc_security_group_ids = [aws_security_group.security_group.id]

  scaling_configuration = var.scaling_configuration

  tags = var.tags
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name        = var.db_parameter_group_name
  family      = var.family
  description = "${var.name}-${var.family}-db-parameter-group"
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group" {
  name        = var.db_cluster_parameter_group_name
  family      = var.family
  description = "${var.name}-${var.family}-cluster-parameter-group"
  tags        = var.tags
}

resource "aws_security_group" "security_group" {
  name        = "${var.name}-rds-aurora"
  description = "${var.name} RDS Auorora security group."
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  tags        = var.tags
}
