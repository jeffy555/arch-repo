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

  georeplication_locations = []

  retention_policy {
    days    = 7
    enabled = false
  }

  trust_policy {
    type    = "Notary"
    enabled = false
  }

  export_policy {
    enabled = true
  }

  public_network_access_enabled = true
}

resource "azurerm_log_analytics_workspace" "workspaceaicloudbuilder9db5" {
  name                = "workspaceaicloudbuilder9db5"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  public_network_access_for_ingestion = "Enabled"
  public_network_access_for_query     = "Enabled"
}

resource "azurerm_dns_zone" "spiritops_in" {
  name                = "spiritops.in"
  resource_group_name = azurerm_resource_group.migrate_scope.name
}

resource "azurerm_container_app_environment" "spiritops_container_app_env" {
  name                = "spiritops-container-app-env"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name

  app_logs_configuration {
    destination = "log-analytics"
    log_analytics_configuration {
      customer_id = "a87dc595-9854-44aa-b93d-3ae1fed44d82"
    }
  }

  workload_profiles {
    name = "Consumption"
    type = "Consumption"
  }

  zone_redundant = false
}

resource "azurerm_container_app" "spiritops_app" {
  name                = "spiritops-app"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  container_app_environment_id = azurerm_container_app_environment.spiritops_container_app_env.id

  revision_mode = "Single"

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
        name      = "DATABASE_URL"
        secret_ref = "database-url"
      }

      env {
        name      = "JWT_SECRET"
        secret_ref = "jwt-secret"
      }

      env {
        name      = "OPENAI_API_KEY"
        secret_ref = "openai-api-key"
      }

      env {
        name      = "BITWARDEN_ACCESS_TOKEN"
        secret_ref = "bitwarden-access-token"
      }

      env {
        name      = "BITWARDEN_PROJECT_ID"
        secret_ref = "bitwarden-project-id"
      }

      probes {
        type                = "Liveness"
        failure_threshold   = 3
        period_seconds      = 10
        success_threshold   = 1
        timeout_seconds     = 5
        tcp_socket {
          port = 23040
        }
      }

      probes {
        type                = "Readiness"
        failure_threshold   = 48
        period_seconds      = 5
        success_threshold   = 1
        timeout_seconds     = 5
        tcp_socket {
          port = 23040
        }
      }

      probes {
        type                = "Startup"
        failure_threshold   = 240
        initial_delay_seconds = 1
        period_seconds      = 1
        success_threshold   = 1
        timeout_seconds     = 3
        tcp_socket {
          port = 23040
        }
      }
    }

    scale {
      min_replicas = 4
      max_replicas = 10

      rule {
        name = "http-scaler"
        http {
          metadata = {
            concurrentRequests = "10"
          }
        }
      }
    }
  }

  ingress {
    external = true
    target_port = 0
    exposed_port = 0
    transport = "Auto"
    traffic {
      weight = 100
      latest_revision = true
    }
    custom_domain {
      name = "www.spiritops.in"
      certificate_id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env/managedCertificates/www.spiritops.in-spiritop-260227063125"
      binding_type = "SniEnabled"
    }
    allow_insecure = false
  }
}
