output "container_registry_id" {
  value = azurerm_container_registry.spiritops.id
}

output "container_app_environment_id" {
  value = azurerm_container_app_environment.spiritops_env.id
}

output "container_app_id" {
  value = azurerm_container_app.spiritops_app.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "dns_zone_id" {
  value = azurerm_dns_zone.spiritops_in.id
}
