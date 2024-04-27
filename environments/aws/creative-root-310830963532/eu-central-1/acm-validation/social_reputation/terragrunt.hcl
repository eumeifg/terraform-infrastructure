include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

dependencies {
  paths = ["../../../../clients-staging-555195170445/eu-central-1/acm/creativeadvtech.ml/"]
}

dependency "zone_creativeadvtech_ml" {
  config_path = "../../../_global/route53/creativeadvtech.ml/"
}

dependency "acm_creativeadvtech_ml" {
  config_path = "../../../../sr-poc-416093388371/eu-central-1/acm/creativeadvtech.ml/"
}

terraform {
  source = "../../../../../../modules/aws/acm_validation///"
}

inputs = {
  aws_route53_zone_id = dependency.zone_creativeadvtech_ml.outputs.route53_zone_zone_id["creativeadvtech.ml"]

  acm_certificate_domain_validation_options = dependency.acm_creativeadvtech_ml.outputs.acm_certificate_domain_validation_options

  tags = local.tags
}
