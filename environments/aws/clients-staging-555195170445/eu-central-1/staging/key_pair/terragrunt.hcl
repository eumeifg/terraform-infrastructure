include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.1"
}

inputs = {
  key_name   = "igw-hosts"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGTz6VKfPggUCDeA2OQvKSCfcNeKxfy7F6uRSh1uAy6YbTus1fAtE4ZGWbwbifDoz3+Ppp9plVn0X7n8neQj106p7bVtr0XtauM9/oa69a4wZHuw9fn1/ZurD0oGPEZ3tQa3Fc6jeP/ydrN9wUO6K8/5wb4kAF0J39j/VL1olWCJNYIEPcD2Ry8ftaxG8qTFQJmhsffrYoAuBDAfh4FQABm6FMGIR94OpncbDVYBo4yh13EMt3etlPS7pSHNOV0UurhUCO/eispnwRGUVqh10gzBzwZd1vSVRKjsw8GJQ4G1iPa9Sw6DEyvLh+3ddTPEl3F23jS1cTxGM2fzHaTEJ9 igw-key"

  tags = local.tags
}
