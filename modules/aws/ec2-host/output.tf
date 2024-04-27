output "ec2_host_id" {
  value = aws_ec2_host.main.id
}

output "ec2_host_arn" {
  value = aws_ec2_host.main.arn
}

output "ec2_host_owner_id" {
  value = aws_ec2_host.main.owner_id
}
