include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.1"
}

inputs = {
  key_name   = "infra_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlC6OHqLub43c2/PDuljqcTU0H/H4vdNAb2DK6z0cld3Xd85Vkz0B3r9d6pCaww6/kaA+dtgqKOdbkTNAS4MNiCOdPQmeWzi8cJgZULZpjGIV9+OSCjdEQn0APJiJyC0mk/YpZB/lpH0i2LNNE04TnEKRwRCwDqZsn6vp+gRCiOhzwGtymEheSvSnIAYFX3fbAnG9iJJEV0xOb4GaMurv6NfkULGP6rfLlcHTbdmUrE0Lt/RyD3pEo71/tT3UmRTYmIZRoRpknAdeaB5YGAyT3UmsrK08o4sAp7cLaGleowcFAD0wO14OvV9pqOlOAi21Nde+qQQ6rri0G+9MmrqUr infra_key"

  tags = local.tags
}
