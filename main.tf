resource "azurerm_resource_group" "migrate_scope" {
  name     = "AICloudBuilder"
  location = "southindia"
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = "workspaceaicloudbuilder9db5"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "spiritops" {
  name                          = "spiritops"
  location                      = "southindia"
  resource_group_name           = azurerm_resource_group.migrate_scope.name
  sku                           = "Basic"
  admin_enabled                 = true
  export_policy_enabled         = true
  retention_policy_in_days      = 7
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"
  zone_redundancy_enabled       = false
}

resource "azurerm_container_app_environment" "spiritops_container_app_env" {
  name                               = "spiritops-container-app-env"
  location                           = "southindia"
  resource_group_name                = azurerm_resource_group.migrate_scope.name
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.workspaceaicloudbuilder9db5.id
  infrastructure_subnet_id           = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
  zone_redundancy_enabled            = false
  workload_profile {
    name                 = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}

resource "azurerm_container_app" "spiritops_app" {
  name                            = "spiritops-app"
  resource_group_name             = azurerm_resource_group.migrate_scope.name
  container_app_environment_id    = azurerm_container_app_environment.spiritops_container_app_env.id
  revision_mode                   = "Single"
  max_inactive_revisions          = 100
  workload_profile_name           = "Consumption"

  secret {
    name = "spiritopsazurecrio-spiritops"
  }
  secret {
    name = "bitwarden-access-token"
  }
  secret {
    name = "bitwarden-project-id"
  }
  secret {
    name = "database-url"
  }
  secret {
    name = "jwt-secret"
  }
  secret {
    name = "openai-api-key"
  }

  ingress {
    target_port        = 0
    external_enabled   = true
    traffic_weight {
      percentage       = 100
      latest_revision  = true
    }
  }

  registry {
    server              = "spiritops.azurecr.io"
    username            = "spiritops"
    password_secret_name = "spiritopsazurecrio-spiritops"
  }

  template {
    min_replicas = 4
    max_replicas = 10
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
        port     = 23040
        transport = "tcp"
      }
      readiness_probe {
        port     = 23040
        transport = "tcp"
      }
      startup_probe {
        port     = 23040
        transport = "tcp"
      }
    }
    http_scale_rule {
      concurrent_requests = "10"
      name = "http-scaler"
    }
  }
}
