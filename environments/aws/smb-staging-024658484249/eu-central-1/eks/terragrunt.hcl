include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "kms" {
  config_path = "../kms"
}

terraform {
  source = "../../../../../modules/aws/eks///"
}

inputs = {
  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.private_subnets

  cluster_encryption_config = [
    {
      provider_key_arn = dependency.kms.outputs.key_arn
      resources        = ["secrets"]
    }
  ]

  worker_groups_launch_template = concat(
    [
      {
        name = "workers-default-spot"

        override_instance_types = ["t3a.small", "t3.small"]

        spot_instance_pools = 1

        asg_min_size         = 1
        asg_max_size         = 1
        asg_desired_capacity = 1

        root_volume_size = 20
        root_volume_type = "gp3"
        root_encrypted   = true

        kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot"
      }
    ]
  )

  map_roles = local.common_vars.locals.eks.map_roles

  kubeconfig_output_path                    = format("%s/%s", get_terragrunt_dir(), "kubeconfig")
  kubeconfig_aws_authenticator_command_args = ["eks", "get-token", "--cluster-name", local.cluster_name, "--role-arn", local.common_vars.locals.eks.kubeconfig_admin_iam_role_arn]

  tags = merge(
    local.tags,
    {
      Description              = "EKS Cluster for ${local.environment}"
      "karpenter.sh/discovery" = local.cluster_name
    }
  )
}
