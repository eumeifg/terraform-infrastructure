resource "aws_efs_file_system" "this" {
  creation_token = var.creation_token

  encrypted = var.encrypted
  kms_key_id = var.kms_key_id

  performance_mode = var.performance_mode

  tags = var.tags
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnets)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = var.security_groups
}
