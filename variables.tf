variable "container_registry_name" {
  description = "The name of the Azure Container Registry."
  type        = string
  default     = "spiritops"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
  default     = "workspaceaicloudbuilder9db5"
}

variable "container_app_name" {
  description = "The name of the Container App."
  type        = string
  default     = "spiritops-app"
}

variable "app_service_environment_name" {
  description = "The name of the App Service Environment."
  type        = string
  default     = "spiritops-container-app-env"
}

variable "dns_zone_name" {
  description = "The name of the DNS Zone."
  type        = string
  default     = "spiritops.in"
}

variable "location" {
  description = "The Azure location where resources will be created."
  type        = string
  default     = "southindia"
}

variable "container_registry_sku" {
  description = "The SKU of the Container Registry."
  type        = string
  default     = "Basic"
}