include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-iam.git//modules/iam-user?ref=v4.3.0"
}

inputs = {
  name                          = "frappe"
  create_iam_user_login_profile = false
}