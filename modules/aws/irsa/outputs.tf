output "roles" {
  value = module.iam_assumable_role_with_oidc
}

output "policies" {
  value = module.iam_policy
}
