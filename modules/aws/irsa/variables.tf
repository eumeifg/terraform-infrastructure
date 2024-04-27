variable "cluster_id" {
  type        = string
  description = "EKS cluster ID"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "Cluster OIDC issuer url"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "iam_assumable_roles_with_oidc_and_policies" {
  type = any
  description = "Map of IAM assumable roles with OIDC with policies and service accounts"

  # Example:
  /*
    iam_assumable_roles_with_oidc_and_policies = {
      external-dns = {
        role_name = "external-dns"

        iam_policy = {
          name = "external-dns"
          policy = data.aws_iam_policy_document.external_dns.json
        }

        oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
      }
    }
  */
}
