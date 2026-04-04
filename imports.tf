import {
  to = azurerm_resource_group.migrate_scope
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder"
}

import {
  to = azurerm_container_registry.spiritops
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.ContainerRegistry/registries/spiritops"
}

import {
  to = azurerm_log_analytics_workspace.workspaceaicloudbuilder9db5
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.OperationalInsights/workspaces/workspaceaicloudbuilder9db5"
}

import {
  to = azurerm_container_app_environment.spiritops_container_app_env
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env"
}

import {
  to = azurerm_container_app.spiritops_app
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/containerApps/spiritops-app"
}

import {
  to = azurerm_dns_zone.spiritops_in
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.Network/dnsZones/spiritops.in"
}
