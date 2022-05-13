provider "kubernetes" {}

data "kubernetes_service_account" "service_account" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
  }
}

data "kubernetes_secret" "service_account_default_secret" {
  metadata {
    name      = data.kubernetes_service_account.service_account.default_secret_name
    namespace = data.kubernetes_service_account.service_account.metadata[0].namespace
  }
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.yml")

  vars = {
    server       = var.server
    namespace    = var.namespace
    cluster_name = var.cluster_name
    context_name = var.context_name
    user_name    = var.user_name
    token        = data.kubernetes_secret.service_account_default_secret.data["token"]
    ca           = base64encode(data.kubernetes_secret.service_account_default_secret.data["ca.crt"])
  }
}
