include {
  path = find_in_parent_folders()
}

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params       = local.common_vars.locals.common_parameters
  environment  = local.common_vars.locals.environment_name
  tags         = local.common_vars.locals.common_tags
  secrets      = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/vault/aws_secret_backend///"
}

inputs = {
    name            = "vault-role"
    credential_type = "assumed_role"
    access_key = local.secrets.access_key
    secret_key = local.secrets.secret_key
    role_arns = ["arn:aws:iam::310830963532:role/DevOps"]
}
