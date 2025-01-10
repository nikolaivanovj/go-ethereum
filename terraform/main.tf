provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "gethdevnetrg" {
  name     = "gethdevnetrg"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "gethdevnetaks" {
  name                = "gethdevnetaks"
  location            = azurerm_resource_group.gethdevnetrg.location
  resource_group_name = azurerm_resource_group.gethdevnetrg.name
  dns_prefix          = "gethdevnet"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.gethdevnetaks.kube_config_raw
  sensitive = true
}
