include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.1"
}

inputs = {
  key_name   = "frappe-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwrXzDeNlG5JfFIvTpHb4FQlk9oWeUJXPOjd2dRobddzQ1kM+Ah6o407Xhw9HfMoJh8zKjp1+sm0RY3L893Ri2tdrXx8HRHOGJAnM77QLNPn7zn3cW0CUbudNpPw6wEdC5Zn57eKLkjqqUlOD1mMZdpO5Zbtqw12xvllBL1sGaU0L/vEc4dPi3jtG30NiHTx3JE8xgarvfKiTN6CJwJP6sQVbH9ZBmIeF1FSLK1QJoQKX9YV87a9T/VB5P0NcyLBM8uWkqcPjSYRz9D3yjAObzW7aGIk4/eBJMfckNeFBZU7gF4iAuQqylCaZH4VwZ34mvlSHVUvraIov0L87uVR1n frappe"

  tags = local.tags
}
