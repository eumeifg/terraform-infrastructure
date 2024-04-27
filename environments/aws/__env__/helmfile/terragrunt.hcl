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

dependency "eks" {
  config_path = "../eks"
}

# EKS IRSA IAM Roles
dependency "irsa_csi" {
  config_path = "../irsa/efs-csi-controller/"
}

dependency "irsa_external_dns" {
  config_path = "../../../creative-root-310830963532/_global/irsa/external-dns-smb-staging"
}

# dependency "irsa_external_dns_priv" {
#   config_path = "../../../smb-staging-024658484249/eu-central-1/irsa"
# }

terraform {
  source = "../../../../../modules/k8s/helmfile///"
}

inputs = {
  kubeconfig       = dependency.eks.outputs.eks.kubeconfig_filename
  helmfile_content = file("helmfile.yaml")

  values = {
    aws_efs_csi_driver = {
      iam_role_arn = dependency.irsa_csi.outputs.roles.aws-efs-csi-controller.iam_role_arn
    }

    external_dns = {
      txtOwnerId   = local.cluster_name
      iam_role_arn = dependency.irsa_external_dns.outputs.roles.external-dns.iam_role_arn
    }

    # external_dns_priv = {
    #   txtOwnerId   = local.cluster_name
    #   iam_role_arn = dependency.irsa_external_dns_priv.outputs.roles.external-dns.iam_role_arn
    # }
  }
}
