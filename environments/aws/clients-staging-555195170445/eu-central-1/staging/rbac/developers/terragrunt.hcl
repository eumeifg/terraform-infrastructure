include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("staging.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name      = local.params.cluster_name
  cluster_role_name = "developers"
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
        api_groups     = ["apps", "batch", "extensions"]
        resource_names = []
        resources      = ["deployments", "daemonsets", "statefulsets", "replicasets", "controllerrevisions", "jobs", "cronjobs", "ingresses"]
        verbs          = ["get", "list", "watch"]
      },
      {
        api_groups     = [""]
        resource_names = []
        resources      = ["namespaces", "configmaps", "events", "pods", "pods/log", "secrets", "services", "pods/attach"]
        #verbs          = ["*"]
        verbs = ["get", "list", "watch"]
      },
      {
        resource_names = []
        api_groups     = [""]
        resources      = ["pods/exec", "pods/portforward"]
        verbs          = ["create"]
      }
    ]
  }

  cluster_role_binding = {
    name = "developers-access-binding"

    role_ref = {
      kind      = "ClusterRole"
      name      = local.cluster_role_name
      api_group = "rbac.authorization.k8s.io"
    }

    subjects = [
      {
        kind      = "User"
        name      = "developer"
        api_group = "rbac.authorization.k8s.io"
      }
    ]
  }
}
