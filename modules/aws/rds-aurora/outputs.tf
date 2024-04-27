output "aurora" {
  value = module.aurora
  sensitive = true
}

output "db_parameter_group" {
  value = aws_db_parameter_group.db_parameter_group
}

output "cluster_parameter_group" {
  value = aws_rds_cluster_parameter_group.cluster_parameter_group
}

output "security_group" {
  value = aws_security_group.security_group
}
