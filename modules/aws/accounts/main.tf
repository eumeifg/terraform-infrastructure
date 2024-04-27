
resource "aws_organizations_account" "this" {
  for_each = var.accounts

  name      = each.key
  email     = each.value.email
  role_name = try(each.value.role_name, var.default_iam_role)

#  lifecycle {
#    ignore_changes = [role_name]
#  }
}
