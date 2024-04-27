resource "vault_aws_secret_backend" "this" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.aws_region
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds = 7200
}

resource "vault_aws_secret_backend_role" "this" {
  backend         = vault_aws_secret_backend.this.path
  name            = var.name
  credential_type = var.credential_type
  role_arns = var.role_arns
}
