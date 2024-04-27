
resource "aws_codeartifact_repository" "this" {
  repository = var.repository
  domain     = aws_codeartifact_domain.this.domain
  tags       = var.tags
}
