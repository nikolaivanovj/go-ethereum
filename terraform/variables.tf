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

variable "disk_size_gb" {
  description = "The size of the Azure managed disk in gigabytes"
  default     = 10
}

variable "node_count" {
  description = "The number of nodes in the Kubernetes cluster"
  default     = 1
}

variable "vm_size" {
  description = "The size of the virtual machines in the Kubernetes cluster"
  default     = "Standard_DS2_v2"
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
}

variable "client_id" {
  description = "The client ID for the Service Principal"
}

variable "client_secret" {
  description = "The client secret for the Service Principal"
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account"
}
