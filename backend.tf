terraform {
  backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "terraformstate1407"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}