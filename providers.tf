terraform {

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_resource_group.default.name
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }

  registry {
    url      = "https://acrtest1407.azurecr.io"
    username = "acrtest1407"
    password = "3ubRuZItsTnSttLhQmgQqB1dAPvQDsgqDQLF4Q8xnH+ACRDTGdjn"
  }
}