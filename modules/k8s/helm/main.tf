resource "helm_release" "this" {
  name             = var.release_name
  repository       = var.repository_url
  chart            = var.chart_name
  version          = var.chart_version
  lint             = true
  verify           = false
  namespace        = var.namespace
  create_namespace = var.create_namespace

  values = [var.values_file]
}
