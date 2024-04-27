include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "eks" {
  config_path = "../../eks"
}

terraform {
  source = "../../../../../../../modules/k8s/secret///"
}

inputs = {
  kubeconfig = dependency.eks.outputs.eks.kubeconfig_filename

  name      = "grafana-datasources"
  namespace = "monitoring"

  data = {
    "datasources.yaml" = "${file("datasources.yaml")}"
  }
}
