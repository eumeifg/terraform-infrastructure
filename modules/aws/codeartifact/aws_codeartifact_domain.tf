resource "aws_codeartifact_domain" "this" {
  domain         = var.domain
  encryption_key = var.kms_key
  tags           = var.tags
}
