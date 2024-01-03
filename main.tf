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

resource "null_resource" "download_chart" {
  provisioner "local-exec" {
    command = <<-EOT
      export HELM_EXPERIMENTAL_OCI=1
      helm registry login acrtest1407.azurecr.io --username b214d587-26ac-4585-8e72-fe4702738a5a --password cg38Q~HCbX0nhDfsnq.9cLs1DZ59PQc8eLaFKbz0
      #helm chart remove mycontainerregistry.azurecr.io/helm/hello-world:v1
      #helm chart pull mycontainerregistry.azurecr.io/helm/hello-world:v1
      #helm chart export mycontainerregistry.azurecr.io/helm/hello-world:v1 --destination ./install
      helm install myhelmtest oci://acrtest1407.azurecr.io/helm/hello-world --version 0.1.0
    EOT
  }
}
