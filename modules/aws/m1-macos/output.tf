output "private_dns_name" {
  value = aws_instance.mac.private_dns
}

output "public_ip" {
  value = aws_instance.mac.public_ip
}

output "private_ip" {
  value = aws_instance.mac.private_ip
}
