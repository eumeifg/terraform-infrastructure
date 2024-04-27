output "squid_private_ip" {
  value = aws_instance.squid.private_ip
}

output "squid_public_ip" {
  value = aws_instance.squid.public_ip
}

output "squid_elastic_ip" {
  value = aws_eip.squid.public_ip
}

output "security_group_ids" {
  value = [aws_security_group.squid.id]
}

output "main_security_group_id" {
  value = aws_security_group.squid.id
}

output "aws_instance_id" {
  value = aws_instance.squid.id
}

