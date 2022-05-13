resource "random_string" "unique_hash" {
  length  = 6
  special = false
  number  = false
  upper   = false
}

locals {
  service_account_namespace = var.service_account_namespace != null ? var.service_account_namespace : var.namespace
}

data "kubernetes_service_account" "service_account" {
  metadata {
    name      = var.service_account_name
    namespace = local.service_account_namespace
  }
}

data "kubernetes_secret" "service_account_default_secret" {
  metadata {
    name      = data.kubernetes_service_account.service_account.default_secret_name
    namespace = data.kubernetes_service_account.service_account.metadata[0].namespace
  }
}

locals {
  rendered_kubeconfig = templatefile("${path.module}/templates/kubeconfig.yml", {
    server       = var.server
    namespace    = var.namespace
    cluster_name = var.cluster_name != null ? var.cluster_name : "cluster-${var.service_account_name}-${random_string.unique_hash.result}"
    context_name = var.context_name != null ? var.context_name : "context-${var.service_account_name}-${random_string.unique_hash.result}"
    user_name    = var.user_name != null ? var.user_name : "user-${var.service_account_name}-${random_string.unique_hash.result}"
    token        = data.kubernetes_secret.service_account_default_secret.data["token"]
    ca           = base64encode(data.kubernetes_secret.service_account_default_secret.data["ca.crt"])
  })
}
