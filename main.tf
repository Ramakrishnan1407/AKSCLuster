resource "azurerm_resource_group" "default" {
  name     = "myakscluster"
  location = "westeurope"

  tags = {
    environment = "Test"
  }
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = "westeurope"
  name                = "myakscluster"
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = 1
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_container_registry" "acr_platform_shared" {
  name                = "acrtest1407"
  resource_group_name = azurerm_resource_group.default.name
  location            = "westeurope"
  sku                 = "Standard"
  admin_enabled       = true
}

resource "helm_release" "my-chart" {
  name                = "test-dev"
  repository          = "https://acrtest1407.azurecr.io/becse/shap/mule/chart/hello-world"
  repository_username = "f024578a-6e8e-479b-a7b5-22c0d278e43f"
  repository_password = "V6n8Q~jFFIyk1Uu-r~Rsu2SR_PPW1kI-gYOGVdsw"
  chart               = "hello-world"
  version             = "0.1.0"
}