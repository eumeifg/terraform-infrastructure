include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "../../../../../../../modules/aws/ses///"
}

inputs = {
  emails = ["gezeugwa@creativeadvtech.com", "akadhim@creativeadvtech.com", "ahmad.mousawi.1990@gmail.com", "support@newton.iq", "almalikiahmed231@gmail.com"]
}
