resource "aws_ses_email_identity" "this" {
  for_each = var.emails
  email    = each.value
}
