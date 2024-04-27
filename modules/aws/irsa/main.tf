module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.3.0"

  for_each       = var.iam_assumable_roles_with_oidc_and_policies

  create_role                   = try(each.value.create_role, true)
  role_name                     = try(each.value.role_name, each.key)
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = concat(try(each.value.iam_policies_arns, []), try([module.iam_policy[each.key].arn], []))
  oidc_fully_qualified_subjects = each.value.oidc_fully_qualified_subjects

  number_of_role_policy_arns = length(try(each.value.iam_policies_arns, [])) + length(try([each.value.iam_policy], []))

  depends_on = [
    module.iam_policy
  ]

  tags = var.tags
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  for_each = {
    for k, v in var.iam_assumable_roles_with_oidc_and_policies :
    k => try(v.iam_policy, null)
    if try(v.iam_policy, null) != null
  }

  name        = each.value.name
  path        = try(each.value.path, "/")
  description = try(each.value.description, "")

  policy = each.value.policy

  tags = var.tags
}
