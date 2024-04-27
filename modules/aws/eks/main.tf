module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.24.0"

  providers = {
    kubernetes = kubernetes.default
  }

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id  = var.vpc_id
  subnets = var.subnets

  enable_irsa = true

  cluster_encryption_config = var.cluster_encryption_config

  worker_groups_launch_template = var.worker_groups_launch_template

  fargate_profiles = var.fargate_profiles

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts

  write_kubeconfig   = true

  kubeconfig_output_path = var.kubeconfig_output_path

  kubeconfig_aws_authenticator_command      = "aws"
  kubeconfig_aws_authenticator_command_args = var.kubeconfig_aws_authenticator_command_args

  cluster_enabled_log_types = ["api","audit","authenticator","controllerManager","scheduler"]

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = var.tags
}
