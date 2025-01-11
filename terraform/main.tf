provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_resource_group" "gethdevnetrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "gethdevnetaks" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.gethdevnetrg.location
  resource_group_name = azurerm_resource_group.gethdevnetrg.name
  dns_prefix          = "gethdevnet"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_managed_disk" "geth_disk" {
  name                 = "geth-disk"
  location             = azurerm_resource_group.gethdevnetrg.location
  resource_group_name  = azurerm_resource_group.gethdevnetrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "example-namespace"
  }
}

resource "kubernetes_persistent_volume_claim" "geth_pvc" {
  metadata {
    name      = "geth-data-pvc"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = "azurefile"
  }
}

resource "kubernetes_persistent_volume" "geth_pv" {
  metadata {
    name = "geth-data-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      azure_disk {
        disk_name     = azurerm_managed_disk.geth_disk.name
        data_disk_uri = azurerm_managed_disk.geth_disk.id
        kind          = "Managed"
        caching_mode  = "ReadWrite"
      }
    }
    storage_class_name = "azurefile"
  }
}

output "kube_config_host" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.host
  sensitive = true
}

output "kube_config_client_certificate" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config_client_key" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.client_key
  sensitive = true
}

output "kube_config_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config_raw
  sensitive = true
}
