resource "helmfile_release_set" "this" {
  kubeconfig = var.kubeconfig
  content    = var.helmfile_content

  values = [
    yamlencode(
    {
      environment = var.environment
    }
    ),
    yamlencode(var.values)
  ]

  environment = var.environment
}
