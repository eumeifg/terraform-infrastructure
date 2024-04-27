include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.0"
}

inputs = {
  key_name   = "creative-admin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA78XyLIQxLpczm6ChDTervWqkYt1qZ4Gtlp6lbRFgfh99tZ5elBAnm/G7RsdSjWmUyt9dydSe9taVbWiH8ZT2G3OUXzBwZOUSpu0OJaezD/y0F94my/+kIO1Q3YkowyTp4oBS2FUUYKc2/mEivMGvfrUNIGjiCKAcRUb/e8AAfbFJpI4Z8cLRqnWu2+RZf5wji2ZcdYsVxS5kKO3/gK5qhUwp/1hIOXM7MHZLzrkqqfwnuRoA+VSK5NIjio3tuHQfTTSkpa6MD/7lzNOtdb6YFXyjkaC9kscgOFjJ9zo9Z7an5nstDDks1Y6b3EBimo2JzvChJ5T3tZera29Zb+4WzlolzxRtaOV4c8DQzAayxj9bT9rHYXFqhNtudxwHMu8bM5E+mPuMxiQYrecRnFKoHxUHupNAFkfOz4ENMm5/ZsnFfo09Cs+jBFGiZxaylXwXC2iGKFqzbj866x7ysja0iDtgOVsfV9AmXp5brW0++qE+BUlMSkb6Xhqz8w5D5qs= creative-admin-key"

  tags = local.tags
}
