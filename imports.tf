import {
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env"
  to = "azurerm_container_app_environment.spiritops_env"
}

import {
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/containerApps/spiritops-app"
  to = "azurerm_container_app.spiritops_app"
}

import {
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.OperationalInsights/workspaces/workspaceaicloudbuilder9db5"
  to = "azurerm_log_analytics_workspace.workspace"
}

import {
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.ContainerRegistry/registries/spiritops"
  to = "azurerm_container_registry.spiritops"
}

import {
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.Network/dnszones/spiritops.in"
  to = "azurerm_dns_zone.spiritops_in"
}

import {
  to = azurerm_resource_group.migrate_scope
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env/managedCertificates/www.spiritops.in-spiritop-260227063125"
}

import {
  to = azurerm_container_app_environment.spiritops_env
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.OperationalInsights/workspaces/workspaceaicloudbuilder9db5"
}

import {
  to = azurerm_container_app.spiritops_app
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.ContainerRegistry/registries/spiritops"
}

import {
  to = azurerm_log_analytics_workspace.workspace
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.Network/dnszones/spiritops.in"
}

import {
  to = azurerm_container_registry.spiritops
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/managedEnvironments/spiritops-container-app-env"
}

import {
  to = azurerm_dns_zone.spiritops_in
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/AICloudBuilder/providers/Microsoft.App/containerApps/spiritops-app"
}
