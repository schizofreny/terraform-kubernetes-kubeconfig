terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }

  required_version = ">= 0.15.0"
}

provider "kubernetes" {
  config_path = "./kubeconfig.yaml"
}

resource "kubernetes_service_account" "test" {
  provider = kubernetes

  metadata {
    name      = "test-user"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding" "test" {
  provider = kubernetes

  metadata {
    name = "test-user"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.test.metadata[0].name
    namespace = kubernetes_service_account.test.metadata[0].namespace
  }
}

module "kubeconfig" {
  source = "../.."

  depends_on = [
    kubernetes_service_account.test
  ]

  service_account_name = kubernetes_service_account.test.metadata[0].name
  namespace            = kubernetes_service_account.test.metadata[0].namespace
  server               = "localhost:8080"

  providers = {
    kubernetes = kubernetes
  }
}

output "kubeconfig" {
  value     = module.kubeconfig.kubeconfig
  sensitive = true
}
