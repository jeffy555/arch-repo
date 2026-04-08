resource "azurerm_resource_group" "migrate_scope" {
  name     = "AICloudBuilder"
  location = "southindia"
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = "workspaceaicloudbuilder9db5"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "southindia"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "spiritops" {
  name                          = "spiritops"
  resource_group_name           = azurerm_resource_group.migrate_scope.name
  location                      = "southindia"
  sku                           = "Basic"
  admin_enabled                 = true
  public_network_access_enabled = true
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}

resource "azurerm_container_app_environment" "spiritops_container_app_env" {
  name                       = "spiritops-container-app-env"
  resource_group_name        = azurerm_resource_group.migrate_scope.name
  location                   = "southindia"
  log_analytics_workspace_id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.OperationalInsights/workspaces/workspaceaicloudbuilder9db5"
}

resource "azurerm_container_app" "spiritops_app" {
  name                         = "spiritops-app"
  resource_group_name          = azurerm_resource_group.migrate_scope.name
  container_app_environment_id = azurerm_container_app_environment.spiritops_container_app_env.id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  secret {
    name  = "spiritopsazurecrio-spiritops"
    value = "..."
  }

  secret {
    name  = "bitwarden-access-token"
    value = "..."
  }

  secret {
    name  = "bitwarden-project-id"
    value = "..."
  }

  secret {
    name  = "database-url"
    value = "..."
  }

  secret {
    name  = "jwt-secret"
    value = "..."
  }

  secret {
    name  = "openai-api-key"
    value = "..."
  }

  registry {
    server               = "spiritops.azurecr.io"
    username             = "spiritops"
    password_secret_name = "spiritopsazurecrio-spiritops"
  }

  ingress {
    target_port                = 23040
    external_enabled           = true
    transport                  = "auto"
    allow_insecure_connections = false

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name  = "spiritops-app"
      image = "spiritops.azurecr.io/spiritops-app:284"
      cpu   = 0.5
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
        name        = "DATABASE_URL"
        secret_name = "database-url"
      }

      env {
        name        = "JWT_SECRET"
        secret_name = "jwt-secret"
      }

      env {
        name        = "OPENAI_API_KEY"
        secret_name = "openai-api-key"
      }

      env {
        name        = "BITWARDEN_ACCESS_TOKEN"
        secret_name = "bitwarden-access-token"
      }

      env {
        name        = "BITWARDEN_PROJECT_ID"
        secret_name = "bitwarden-project-id"
      }

      liveness_probe {
        transport                = "TCP"
        port                     = 23040
        initial_delay            = 1
        interval_seconds         = 10
        timeout                  = 5
        failure_count_threshold  = 3
      }

      readiness_probe {
        transport                = "TCP"
        port                     = 23040
        initial_delay            = 1
        interval_seconds         = 5
        timeout                  = 5
        failure_count_threshold  = 48
        success_count_threshold  = 1
      }

      startup_probe {
        transport                = "TCP"
        port                     = 23040
        initial_delay            = 1
        interval_seconds         = 1
        timeout                  = 3
        failure_count_threshold  = 240
      }
    }

    min_replicas = 4
    max_replicas = 10
  }
}
