resource "azurerm_resource_group" "default" {
  name     = "myaksclusternewram"
  location = "westeurope"

  tags = {
    environment = "Test"
  }
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

/*
resource "azurerm_kubernetes_cluster" "aks" {
  location                  = "westeurope"
  name                      = "myaksclusternew"
  resource_group_name       = azurerm_resource_group.default.name
  dns_prefix                = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  automatic_channel_upgrade = "rapid"
 #private_cluster_enabled   = true 
  

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    temporary_name_for_rotation = "temp"
    vm_size    = "standard_a2m_v2"
    node_count = 1
    enable_auto_scaling = false
  }

  storage_profile {
    blob_driver_enabled = true
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
    day_of_week = "Wednesday"
    start_time  = "22:10"
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
*/

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

resource "azurerm_resource_group" "example" {
  name     = "appgatewayram01"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_key_vault" "example" {
  name                        = "examplekeyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

