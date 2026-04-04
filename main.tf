resource "azurerm_resource_group" "migrate_scope" {
  name     = "AICloudBuilder"
  location = "southindia"
}

resource "azurerm_container_registry" "spiritops" {
  name                = "spiritops"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  sku                 = "Basic"
  admin_enabled       = true
  anonymous_pull_enabled = false
  data_endpoint_enabled = false
  export_policy_enabled = true
  public_network_access_enabled = true
  quarantine_policy_enabled = false
  retention_policy_in_days = 7
  trust_policy_enabled = false
  zone_redundancy_enabled = false
  network_rule_bypass_option = "AzureServices"
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = "workspaceaicloudbuilder9db5"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  internet_ingestion_enabled = true
  internet_query_enabled = true
}

resource "azurerm_container_app" "spiritops_app" {
  name                       = "spiritops-app"
  resource_group_name        = azurerm_resource_group.migrate_scope.name
  container_app_environment_id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env"
  revision_mode              = "Single"
  max_inactive_revisions     = 100
  workload_profile_name      = "Consumption"

  ingress {
    target_port = 80
    external_enabled = true
    transport = "auto"
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  registry {
    server = "spiritops.azurecr.io"
    username = "spiritops"
    password_secret_name = "spiritopsazurecrio-spiritops"
  }

  secret {
    name = "spiritopsazurecrio-spiritops"
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
        name = "DATABASE_URL"
        secret_name = "database-url"
      }
      env {
        name = "JWT_SECRET"
        secret_name = "jwt-secret"
      }
      env {
        name = "OPENAI_API_KEY"
        secret_name = "openai-api-key"
      }
      env {
        name = "BITWARDEN_ACCESS_TOKEN"
        secret_name = "bitwarden-access-token"
      }
      env {
        name = "BITWARDEN_PROJECT_ID"
        secret_name = "bitwarden-project-id"
      }

      liveness_probe {
        port = 23040
        transport = "TCP"
        failure_count_threshold = 3
        interval_seconds = 10
        timeout = 5
      }

      readiness_probe {
        port = 23040
        transport = "TCP"
        failure_count_threshold = 48
        interval_seconds = 5
        timeout = 5
      }

      startup_probe {
        port = 23040
        transport = "TCP"
        failure_count_threshold = 240
        initial_delay = 1
        interval_seconds = 1
        timeout = 3
      }
    }

    http_scale_rule {
      concurrent_requests = "10"
      name = "http-scaler"
    }
  }
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}

resource "azurerm_container_app_environment" "spiritops_container_app_env" {
  name                = "spiritops-container-app-env"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspaceaicloudbuilder9db5.id
  zone_redundancy_enabled = false

  workload_profile {
    name = "Consumption"
    workload_profile_type = "Consumption"
  }
}
