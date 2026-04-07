resource "azurerm_resource_group" "migrate_scope" {
  name     = "myresume-live-rg"
  location = "centralus"
}

resource "azurerm_service_plan" "asp_myresumeliverg_ade0" {
  name                = "ASP-myresumeliverg-ade0"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "centralus"
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_storage_account" "preacherjefferson" {
  name                         = "preacherjefferson"
  resource_group_name          = azurerm_resource_group.migrate_scope.name
  location                     = "centralindia"
  account_tier                 = "Standard"
  account_replication_type     = "RAGRS"
  https_traffic_only_enabled   = true
  allow_nested_items_to_be_public = true
  shared_access_key_enabled    = true
  min_tls_version              = "TLS1_2"
  access_tier                  = "Hot"
  large_file_share_enabled     = true
}

resource "azurerm_virtual_network" "myresume_live_rg_vnet" {
  name                = "myresume-live-rg-vnet"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "centralindia"
  address_space       = ["10.224.0.0/12"]
}

resource "azurerm_monitor_action_group" "recommended_alert_rules_ag_6b460f" {
  name                = "RecommendedAlertRules-AG-6b460f"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  short_name          = "alert6b460f"

  email_receiver {
    name                   = "Email_-EmailAction-"
    email_address          = "jeffersonimmanuel5@gmail.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_application_insights" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "centralus"
  application_type    = "web"
}

resource "azurerm_monitor_action_group" "application_insights_smart_detection" {
  name                = "Application Insights Smart Detection"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  short_name          = "SmartDetect"

  arm_role_receiver {
    name                   = "Monitoring Contributor"
    role_id                = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }

  arm_role_receiver {
    name                   = "Monitoring Reader"
    role_id                = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }
}

resource "azurerm_linux_web_app" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "centralus"
  service_plan_id     = azurerm_service_plan.asp_myresumeliverg_ade0.id

  site_config {
    application_stack {
      node_version = "22-lts"
    }
  }

  https_only             = true
  client_affinity_enabled = false
}
