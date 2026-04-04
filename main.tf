resource "azurerm_resource_group" "migrate_scope" {
  name     = "AICloudBuilder"
  location = "southindia"
}

resource "azurerm_container_registry" "spiritops" {
  name                = "spiritops"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "southindia"
  sku                 = "Basic"
}

resource "azurerm_container_app_environment" "spiritops_env" {
  name                = "spiritops-container-app-env"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "southindia"
}

resource "azurerm_container_app" "spiritops_app" {
  name                       = "spiritops-app"
  resource_group_name        = azurerm_resource_group.migrate_scope.name
  location                   = "southindia"
  container_app_environment_id = azurerm_container_app_environment.spiritops_env.id
  revision_mode              = "Single"

  template {
    container {
      name  = "spiritops-container"
      image = var.container_image
    }
  }
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "workspaceaicloudbuilder9db5"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "southindia"
  sku                 = "PerGB2018"
}

# TODO: Add azurerm_container_app_environment_managed_certificate when API details are available

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}
