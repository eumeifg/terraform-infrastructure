resource "kubernetes_cluster_role" "this" {
  count = var.cluster_role != null ? 1 : 0

  metadata {
    name = var.cluster_role.name
  }

  dynamic "rule" {
    for_each = var.cluster_role.rules

    content {
      api_groups     = rule.value.api_groups
      resource_names = rule.value.resource_names
      resources      = rule.value.resources
      verbs          = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  count = var.cluster_role_binding != null ? 1 : 0

  metadata {
    name = var.cluster_role_binding.name
  }

  role_ref {
    kind      = var.cluster_role_binding.role_ref.kind
    name      = var.cluster_role_binding.role_ref.name
    api_group = var.cluster_role_binding.role_ref.api_group
  }

  dynamic "subject" {
    for_each = var.cluster_role_binding.subjects

    content {
      kind      = subject.value.kind
      name      = subject.value.name
      api_group = subject.value.api_group
    }
  }
}
