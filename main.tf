provider "azurerm" {
  features {}
}

resource "azurerm_container_app" "spiritops_app" {
  name                = var.spiritops_app_name
  resource_group_name = azurerm_resource_group.aicloudbuilder.name
  location            = var.location
  managed_environment_id = azurerm_app_managed_environment.spiritops_container_app_env.id
  # Additional properties inferred from standard mapping
}

resource "azurerm_container_registry" "spiritops" {
  name                = var.spiritops_registry_name
  resource_group_name = azurerm_resource_group.aicloudbuilder.name
  location            = var.location
  sku                 = var.spiritops_registry_sku
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = var.workspace_name
  resource_group_name = azurerm_resource_group.aicloudbuilder.name
  location            = var.location
  sku                 = var.workspace_sku
}

resource "azurerm_app_managed_environment" "spiritops_container_app_env" {
  name                = var.spiritops_container_app_env_name
  resource_group_name = azurerm_resource_group.aicloudbuilder.name
  location            = var.location
}

resource "azurerm_app_managed_certificate" "spiritops_certificate" {
  name                = var.spiritops_certificate_name
  managed_environment_id = azurerm_app_managed_environment.spiritops_container_app_env.id
  # Additional properties inferred from standard mapping
}

resource "azurerm_dns_zone" "spiritops_dnszone" {
  name                = var.spiritops_dnszone_name
  resource_group_name = azurerm_resource_group.aicloudbuilder.name
  location            = var.location
}