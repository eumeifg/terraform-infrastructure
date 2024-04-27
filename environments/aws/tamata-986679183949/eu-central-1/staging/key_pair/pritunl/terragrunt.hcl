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
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.1"
}

inputs = {
  key_name   = "pritunl"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3gyDpkXGhgd1wB/9g/5ijaqECMHh8Enljiq/tBvf9AIHOwe2X2LUNNHjUOJCht1g8tPnb5j990kLbKVNYC+W3gPJjSB9BJiqCPIDNrGbKOk5GzvyAhcGrRLLn3tQY8CYoWX7Zw64THerabej/HfFgf7XtTKkczu/S/AErZn7Y7kWjr5SkBKzRBanJ0UrDs3Evgi/f+Ty7lWX+GSqUlb1bEXgi/QfLZVeRg+R6fdqNCg/VyaDK5ush6yYkzb5B1poDRyQOozlGf0lj0KGP9/TeC3ur8jwtkV0IJ9Iw1K9ax4KOaDD6JVbWuOfa+uYKM8jAHSB7qmkqHCzB+wJdsLh3"

  tags = local.tags
}
