resource "azurerm_resource_group" "migrate_scope" {
  name     = "AICloudBuilder"
  location = "southindia"
}

resource "azurerm_container_registry" "spiritops" {
  name                = "spiritops"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  sku                 = "Basic"

  admin_enabled = true

  public_network_access_enabled = true
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = "workspaceaicloudbuilder9db5"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "spiritops_container_app_env" {
  name                = "spiritops-container-app-env"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}

resource "azurerm_container_app" "spiritops_app" {
  name                = "spiritops-app"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  container_app_environment_id = azurerm_container_app_environment.spiritops_container_app_env.id

  revision_mode = "Single"

  template {
    container {
      name   = "spiritops-app"
      image  = "spiritops.azurecr.io/spiritops-app:284"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "NODE_ENV"
        value = "production"
      }

      env {
        name  = "PORT"
        value = "9005"
      }

      env {
        name = "DATABASE_URL"
      }

      env {
        name = "JWT_SECRET"
      }

      env {
        name = "OPENAI_API_KEY"
      }

      env {
        name = "BITWARDEN_ACCESS_TOKEN"
      }

      env {
        name = "BITWARDEN_PROJECT_ID"
      }
    }
  }

  ingress {
    target_port = 0
    exposed_port = 0
    transport = "Auto"

    traffic_weight = 100

    custom_domain {
      name = "www.spiritops.in"
      certificate_id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env/managedCertificates/www.spiritops.in-spiritop-260227063125"
    }
  }
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}
