provider "azurerm" {
  features {}
}

resource "azurerm_container_app" "spiritops_app" {
  name                = var.container_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ai_cloud_builder.name
  managed_environment_id = azurerm_app_managed_environment.spiritops_container_app_env.id
}

resource "azurerm_app_managed_environment" "spiritops_container_app_env" {
  name                = var.managed_environment_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ai_cloud_builder.name
}

resource "azurerm_container_registry" "spiritops" {
  name                = var.container_registry_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ai_cloud_builder.name
  sku                 = var.container_registry_sku
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ai_cloud_builder.name
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.ai_cloud_builder.name
  location            = var.dns_zone_location
}
