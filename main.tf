resource "azurerm_resource_group" "migrate_scope" {
  name     = "myresume-live-rg"
  location = "global"
}

resource "azurerm_monitor_action_group" "application_insights_smart_detection" {
  name                = "Application Insights Smart Detection"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "global"

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

resource "azurerm_application_insights" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  application_type    = "web"
}

resource "azurerm_storage_account" "preacherjefferson" {
  name                     = "preacherjefferson"
  location                 = "centralindia"
  resource_group_name      = azurerm_resource_group.migrate_scope.name
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  allow_nested_items_to_be_public = true
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = true

  min_tls_version = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_network" "myresume_live_rg_vnet" {
  name                = "myresume-live-rg-vnet"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  address_space       = ["10.224.0.0/12"]

  subnet {
    name                      = "default"
    address_prefixes          = ["10.224.0.0/16"]
    private_endpoint_network_policies = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints         = ["Microsoft.ContainerRegistry"]
  }
}

resource "azurerm_monitor_action_group" "recommended_alert_rules_ag_6b460f" {
  name                = "RecommendedAlertRules-AG-6b460f"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  location            = "global"

  email_receiver {
    name                   = "Email_-EmailAction-"
    email_address          = "jeffersonimmanuel5@gmail.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_service_plan" "asp_myresumeliverg_ade0" {
  name                = "ASP-myresumeliverg-ade0"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "jeffersonimmanuel" {
  name                = "jeffersonimmanuel"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.migrate_scope.name
  service_plan_id     = azurerm_service_plan.asp_myresumeliverg_ade0.id

  site_config {
    application_stack {
      node_version = "22-lts"
    }
  }

  https_only = true

  tags = {
    "hidden-link: /app-insights-resource-id" = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/myresume-live-rg/providers/microsoft.insights/components/jeffersonimmanuel"
  }
}
