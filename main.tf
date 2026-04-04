resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_container_app" "spiritops_app" {
  name                = var.container_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  managed_environment_id = azurerm_app_managed_environment.spiritops_env.id
}

resource "azurerm_container_registry" "spiritops_registry" {
  name                = var.container_registry_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.container_registry_sku
}

resource "azurerm_app_managed_environment" "spiritops_env" {
  name                = var.managed_environment_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_dns_zone" "spiritops_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.main.name
  location            = "global"
}

resource "azurerm_app_managed_certificate" "spiritops_certificate" {
  name                = var.certificate_name
  managed_environment_id = azurerm_app_managed_environment.spiritops_env.id
  hostname           = var.certificate_hostname
}
