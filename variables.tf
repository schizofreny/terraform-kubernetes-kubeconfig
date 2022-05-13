variable "service_account_name" {
  type        = string
  description = "Service account name that is used for generating kubeconfig."
}

variable "service_account_namespace" {
  type        = string
  description = "Namespace that the service account is in. If not provided, the 'namespace' variable is used."
  default     = null
}

variable "namespace" {
  type        = string
  description = "Namespace that will be injected into the kubeconfig."
  default     = "default"
}

variable "server" {
  type        = string
  description = "Kubernetes api server address."
}

variable "cluster_name" {
  type        = string
  description = "Cluster name that will be injected into the kubeconfig."
  default     = null
}

variable "context_name" {
  type        = string
  description = "Context name that will be injected into the kubeconfig."
  default     = null
}

variable "user_name" {
  type        = string
  description = "User name that will be injected into the kubeconfig."
  default     = null
}
