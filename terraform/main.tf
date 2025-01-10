provider "azurerm" {
  features {}
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
        disk_name    = azurerm_managed_disk.geth_disk.name
        disk_uri     = azurerm_managed_disk.geth_disk.id
        kind         = "Managed"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "geth_pvc" {
  metadata {
    name = "geth-data-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config_raw
  sensitive = true
}
