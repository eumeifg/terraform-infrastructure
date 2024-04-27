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
  source = "${get_parent_terragrunt_dir()}/../modules/aws/accounts///"
}

inputs = {

  # TODO: assign accounts to OUs

  accounts = {

    clients-staging = {
      email       = "devops+clients@creativeadvtech.com"
      description = "Staging and Production account for clients-staging"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    eschool = {
      email       = "devops+eschool@creativeadvtech.com"
      description = "AWS account for eSchool project"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    frappe = {
      email       = "devops+frappe-erp@creativeadvtech.com"
      description = "Staging and produtions  account for frappe ERP"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    infra = {
      email       = "devops@creativeadvtech.com"
      description = "Shared infrastructure for running customer-agnostic services"
      parent_id   = "ou-xrh5-fykqqoyg"
    },

    iqnbb-staging = {
      email       = "devops+iqnbb-staging@creativeadvtech.com"
      description = "Staging account for IQNBB"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    interactive-contents-stg = {
      email       = "devops+interactive-contents-stg@creativeadvtech.com"
      description = "Staging account for interactive contents"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    network-service = {
      email       = "network-service@creativeadvtech.com"
      description = "Staging account for Network-Service"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    smb-staging = {
      email       = "devops+smb-staging@creativeadvtech.com"
      description = "Staging account for SMB"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    smn-staging = {
      email       = "devops+smn-staging@creativeadvtech.com"
      description = "Staging account for ScanMyNet"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    snp-staging = {
      email       = "devops-snp@creativeadvtech.com"
      description = "Staging account for SNP"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    social-reputation-poc = {
      email       = "social-reputation@creativeadvtech.com"
      description = "Sandbox account for Social Reputation Project"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    ta3leem-staging = {
      email       = "devops+ta3leem-staging@creativeadvtech.com"
      description = "Staging account for Ta3leem"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    tamata = {
      email       = "devops-tamata@creativeadvtech.com"
      description = "Staging and Production account for TAMATA"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    tasleem-staging = {
      email       = "devops+tasleem-staginbg@creativeadvtech.com"
      description = "Staging account for Tasleem"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    taza-staging = {
      email       = "devops+taza-staging@creativeadvtech.com"
      description = "Staging account for TAZA"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    Tejan = {
      email       = "devops-tejan@creativeadvtech.com"
      description = "Staging account for Tejan"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    transcoder-stg = {
      email       = "devops+transcoder-stg@creativeadvtech.com"
      description = "Staging account for Tejan"
      parent_id   = "ou-xrh5-kmakds4a"
    }

    # This account has to be removed.

    globaltek = {
      email       = "devops+globaltek-erp@creativeadvtech.com"
      description = "Staging account for GlobalTeK ERP"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    ttech = {
      email       = "devops-ttech@creativeadvtech.com"
      description = "Staging and Production account for Ttech"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    tabadul = {
      email       = "devops+tabadul@creativeadvtech.com"
      description = "Production account for Tabadul"
      parent_id   = "ou-xrh5-kmakds4a"
    },

    Newton-Results-Prod = {
      email       = "newton+prod@creativeadvtech.com"
      description = "test env for Newton account"
      parent_id   = "ou-xrh5-x9x8kum9"
    },

    "Pawel Kalinowski" = {
      email       = "pkalinowski@creativeadvtech.com"
      description = "Sandbox account for Pawel Kalinowski"
      parent_id   = "ou-xrh5-x9x8kum9"
    },


    ############################################
    # Sandbox AWS accounts for Developers
    "Dominik Malowiecki" = {
      email       = "dmalowiecki@creativeadvtech.com"
      description = "Sandbox account for Dominik Malowiecki"
      parent_id   = "ou-xrh5-9sz9oxtb"
    },

    "NareshTest" = {
      email       = "nmakwana@creativeadvtech.com"
      description = "Sandbox account for Naresh Makwana"
      parent_id   = "ou-xrh5-9sz9oxtb"
    },

    "SaitGhassan" = {
      email       = "sghassan@creativeadvtech.com"
      description = "Sandbox account for Saif Ghassan"
      parent_id   = "ou-xrh5-9sz9oxtb"
    },

    "Saif Ali" = {
      email       = "sali@creativeadvtech.com"
      description = "Sandbox account for Saif Ali"
      parent_id   = "ou-xrh5-9sz9oxtb"
    },

  }
}
