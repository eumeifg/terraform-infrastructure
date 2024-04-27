include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks"
}

terraform {
  source = "../../../../../../../modules/k8s/rbac///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  cluster_role = {
    name = "developers"

    rules = [
      {
        api_groups     = ["", "apps", "batch", "extensions"]
        resource_names = []
        resources      = ["*"]
        verbs          = ["get", "list", "watch"]
      },
      {
        api_groups     = [""]
        resource_names = []
        resources      = ["pods/exec"]
        verbs          = ["create"]
      }
    ]
  }
}
