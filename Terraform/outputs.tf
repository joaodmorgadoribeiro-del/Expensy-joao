output "cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "resource_group_name" {
  value = "joao_rg"
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.k8s.id
}

output "host" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  sensitive = true
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}