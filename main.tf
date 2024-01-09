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
  location                  = "westeurope"
  name                      = "myakscluster2"
  resource_group_name       = azurerm_resource_group.default.name
  dns_prefix                = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  automatic_channel_upgrade = "patch"

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

  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Tuesday"
    start_time  = "21:40"
    utc_offset  = "+01:00"
  }
}

resource "azurerm_container_registry" "acr_platform_shared" {
  name                = "acrtest1407"
  resource_group_name = azurerm_resource_group.default.name
  location            = "westeurope"
  sku                 = "Standard"
  admin_enabled       = true
}

/*
resource "helm_release" "hello-world" {
name = "hello-world"
chart = "hello-world"
namespace = "hello-world"
create_namespace = "true"
repository = "oci://acrtest1407.azurecr.io/helm/hello-world"
version = "0.1.0"
wait = "true"
force_update = "true"
}*/

/*
resource "null_resource" "aks_upgrade" {
  
  provisioner "local-exec" {
    command = "az aks maintenanceconfiguration add -g ${azurerm_resource_group.default.name} --cluster-name ${azurerm_kubernetes_cluster.aks.name} --name aksManagedAutoUpgradeSchedule --day-of-week Tuesday --interval-weeks 1 --duration 4 --utc-offset +01:00 --start-time 14:30"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}*/

