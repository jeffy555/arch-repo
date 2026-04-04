output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "container_app_id" {
  value = azurerm_container_app.spiritops_app.id
}

output "container_registry_id" {
  value = azurerm_container_registry.spiritops_registry.id
}

output "managed_environment_id" {
  value = azurerm_app_managed_environment.spiritops_env.id
}

output "dns_zone_id" {
  value = azurerm_dns_zone.spiritops_dns_zone.id
}

output "managed_certificate_id" {
  value = azurerm_app_managed_certificate.spiritops_certificate.id
}
