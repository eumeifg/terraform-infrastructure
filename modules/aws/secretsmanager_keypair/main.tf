resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = var.name_prefix
  public_key = tls_private_key.key.public_key_openssh
}

# store private key in AWS Secrets Maneger
resource "aws_secretsmanager_secret" "secret_private_key" {
  name        = "${var.name_prefix}-private-key"
  description = var.description
  tags = merge(
    var.tags,
    { "Name" : "${var.name_prefix}-private-key" }
  )
}

resource "aws_secretsmanager_secret_version" "secret_private_key_value" {
  secret_id     = aws_secretsmanager_secret.secret_private_key.id
  secret_string = tls_private_key.key.private_key_pem
}

# store public key in AWS Secrets Maneger
resource "aws_secretsmanager_secret" "secret_public_key" {
  name        = "${var.name_prefix}-public-key"
  description = var.description
  tags = merge(
    var.tags,
    { "Name" : "${var.name_prefix}-public-key" }
  )
}

resource "aws_secretsmanager_secret_version" "secret_public_key_value" {
  secret_id     = aws_secretsmanager_secret.secret_public_key.id
  secret_string = tls_private_key.key.public_key_openssh
}
