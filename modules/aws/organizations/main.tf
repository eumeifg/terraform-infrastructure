resource "aws_organizations_organization" "this" {
  feature_set = var.feature_set

  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
}

resource "aws_organizations_account" "this" {
  name                       = var.master_account_name
  email                      = var.email
  iam_user_access_to_billing = var.iam_user_access_to_billing
  role_name                  = var.role_name
  tags                       = var.tags
}

resource "aws_organizations_organizational_unit" "main" {
  name      = var.main_ou
  parent_id = aws_organizations_organization.this.roots[0].id
  tags      = var.tags
}

resource "aws_organizations_organizational_unit" "projects" {
  name      = var.projects
  parent_id = aws_organizations_organization.this.roots[0].id
  tags      = var.tags
}

resource "aws_organizations_organizational_unit" "sandboxes" {
  name      = var.sandboxes
  parent_id = aws_organizations_organization.this.roots[0].id
  tags      = var.tags
}
