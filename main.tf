resource "azurerm_resource_group" "migrate_scope" {
  name     = "myresume-live-rg"
  location = "centralindia"
}

resource "azurerm_storage_account" "preacherjefferson" {
  name                     = "preacherjefferson"
  resource_group_name      = azurerm_resource_group.migrate_scope.name
  location                 = "centralindia"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_blob_public_access = true
  allow_shared_key_access  = true
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true
  large_file_share_enabled = true

  network_rules {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
  }

  encryption {
    services {
      blob {
        enabled = true
      }
      file {
        enabled = true
      }
    }
    key_source = "Microsoft.Storage"
  }
}

resource "azurerm_application_insights" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  application_type    = "web"
}

resource "azurerm_app_service_plan" "asp_myresumeliverg_ade0" {
  name                = "ASP-myresumeliverg-ade0"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_virtual_network" "myresume_live_rg_vnet" {
  name                = "myresume-live-rg-vnet"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name

  address_space = ["10.224.0.0/12"]

  subnet {
    name           = "default"
    address_prefix = "10.224.0.0/16"

    service_endpoints = ["Microsoft.ContainerRegistry"]
  }
}

resource "azurerm_monitor_action_group" "application_insights_smart_detection" {
  name                = "Application Insights Smart Detection"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  short_name          = "SmartDetect"

  arm_role_receiver {
    role_id               = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }

  arm_role_receiver {
    role_id               = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "recommended_alert_rules_ag_6b460f" {
  name                = "RecommendedAlertRules-AG-6b460f"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  short_name          = "alert6b460f"

  email_receiver {
    name                    = "Email_-EmailAction-"
    email_address           = "jeffersonimmanuel5@gmail.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_linux_web_app" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  service_plan_id     = azurerm_app_service_plan.asp_myresumeliverg_ade0.id

  site_config {
    linux_fx_version = "NODE|22-lts"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  https_only = true
}

# migrateops: TODO - Add azurerm_container_app and azurerm_container_app_environment resources if needed
