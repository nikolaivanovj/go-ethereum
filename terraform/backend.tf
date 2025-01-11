# Switching back to Azure backend for state storage
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state-rg"
    storage_account_name  = "gethdevnetacct42"
    container_name        = "terraformstatecontainer"
    key                   = "terraform.tfstate"
  }
}

# Removed the azurerm provider block to avoid duplication
# provider "azurerm" {
#   features {}
# }

resource "azurerm_resource_group" "terraform_state_rg" {
  name     = "terraform-state-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "terraform_state_sa" {
  name                     = "gethdevnetacct42"
  resource_group_name      = azurerm_resource_group.terraform_state_rg.name
  location                 = azurerm_resource_group.terraform_state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "terraform_state_container" {
  name                  = "terraformstatecontainer"
  storage_account_id    = azurerm_storage_account.terraform_state_sa.id
  container_access_type = "private"
}

output "state_account_name" {
  value = azurerm_storage_account.terraform_state_sa.name
}

output "state_container_name" {
  value = azurerm_storage_container.terraform_state_container.name
}

output "state_resource_group" {
  value = azurerm_resource_group.terraform_state_rg.name
}
