include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  params      = local.common_vars.locals.common_parameters
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags

  cluster_name = local.params.cluster_name

  cluster_autoscaler_tags = [
    {
      "key"                 = "k8s.io/cluster-autoscaler/enabled"
      "propagate_at_launch" = "false"
      "value"               = "true"
    },
    {
      "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
      "propagate_at_launch" = "false"
      "value"               = "true"
    }
  ]
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

# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=inputs
inputs = {
  cluster_name    = local.cluster_name
  cluster_version = "1.21"

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
        name = "workers-on-demand"

        instance_type = "m5a.large"

        asg_min_size         = 0
        asg_max_size         = 0
        asg_desired_capacity = 0

        // tags = local.cluster_autoscaler_tags
      },
    ],
    [

      # Provision workers ASGs per AZ
      # required for cluster-autoscaler proper working:
      # https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#common-notes-and-gotchas
      for index, subnet in dependency.vpc.outputs.private_subnets :
      {
        name = "workers-spot-${index}"

        subnets = [subnet]

        override_instance_types = ["t3a.large"]

        spot_instance_pools = 1

        asg_min_size         = 1
        asg_max_size         = 3
        asg_desired_capacity = 1

        kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot"

        tags = local.cluster_autoscaler_tags
      }
    ]
  )

  map_roles = local.common_vars.locals.eks.map_roles
  # map_users = local.common_vars.locals.eks.map_users

  kubeconfig_output_path                    = format("%s/%s", get_terragrunt_dir(), "kubeconfig")
  kubeconfig_aws_authenticator_command_args = ["eks", "get-token", "--cluster-name", local.cluster_name, "--role-arn", local.common_vars.locals.eks.kubeconfig_admin_iam_role_arn]

  tags = merge(
    local.tags,
    {
      Description = "EKS Cluster for ${local.environment}"
    }
  )
}
