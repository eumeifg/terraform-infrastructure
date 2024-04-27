# provider "helm" {
#   kubernetes {
#     host                   = var.cluster_endpoint
#     cluster_ca_certificate = base64decode(var.cluster_ca_cert)
#     exec {
#       api_version = "client.authentication.k8s.io/v1alpha1"
#       args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
#       command     = "aws"
#     }
#   }
# }

#TODO: [DEVOPS-108] this is temporary solution to allow execute terraform from local env and must be replaced with edfinition abouve to enable to run in in a pipline
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
