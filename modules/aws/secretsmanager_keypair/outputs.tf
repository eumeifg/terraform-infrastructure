output "key_name" {
  description = "Name of the keypair"
  value       = aws_key_pair.keypair.key_name
}

output "secret_private_key_name" {
  description = "Name of the private key in AWS Secters Manager Secret name"
  value       = aws_secretsmanager_secret.secret_private_key.name
}

output "secret_public_key_name" {
  description = "Name of the public key in AWS Secters Manager Secret name"
  value       = aws_secretsmanager_secret.secret_public_key.name
}
