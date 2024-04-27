resource "aws_kms_key" "this" {
  is_enabled  = var.is_enabled
  description = var.description

  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  policy                   = var.policy
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  tags = var.tags
}


resource "aws_kms_alias" "this" {
  name          = var.alias_name
  target_key_id = aws_kms_key.this.id
}
