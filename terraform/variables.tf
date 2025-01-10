variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "gethdevnetrg"
}

variable "location" {
  description = "The Azure location where resources will be deployed"
  default     = "West Europe"
}

variable "kubernetes_cluster_name" {
  description = "The name of the Kubernetes cluster"
  default     = "gethdevnetaks"
}
