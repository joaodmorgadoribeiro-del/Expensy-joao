resource "random_pet" "cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "dns_prefix" {
  prefix = "dns"
}

resource "azurerm_container_registry" "acr" {
  name                = "expensynacr"
  resource_group_name = "joao-rg"
  location            = var.resource_group_location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.resource_group_location
  name                = "joaocluster"
  resource_group_name = "joao-rg"
  dns_prefix          = random_pet.dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2ms"
    node_count = var.node_count
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
